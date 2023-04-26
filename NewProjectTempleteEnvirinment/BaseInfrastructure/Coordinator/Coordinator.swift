import UIKit

class Coordinator {
    
    static let shared = Coordinator()
    
    private      var compositionRoot       : CompositionRoot             { CompositionRoot.sharedInstance                }
    private      var appDelegate           : AppDelegate                 { UIApplication.shared.delegate as! AppDelegate }
    private(set) var authFlowNavController : CustomNavigationController
    private(set) var mainFlowNavController : CustomNavigationController?
    
    fileprivate var isMenuOpened: Bool = false
    
    /// Will return navigation controller of highest level
    var topExistNavigationLevel: CustomNavigationController {
        
        if let mainFlowNavController {
            return mainFlowNavController
        } else {
            return authFlowNavController
        }
    }
    
    private init() {
        let vc = CompositionRoot.sharedInstance.resolveCoordinatorViewController()
        authFlowNavController = CustomNavigationController(rootViewController: vc)
        mainFlowNavController = nil
    }
    
    func updateNavAppearance() {
        authFlowNavController.updateAppearance()
        mainFlowNavController?.updateAppearance()
    }
    
}



// MARK: Main action
extension Coordinator {
    func move(as action: CoordinatorAction) {
        switch action {
        case .pushOrPopTill   (let vc  ): self.pushOrPopTo(vc.viewController, on: vc.flowDestination)
        case .push            (let vc  ): self.push       (vc.viewController, on: vc.flowDestination)
        case .present         (let vc  ): self.present    (vc.viewController                        )
        case .popTill         (let vc  ): self.popTill    (vc.viewController, on: vc.flowDestination)
        case .pop             (let flow): self.pop        (                   on: flow              )
        case .showMenu(let fromMenuItem): self.showMenuAction(fromItem: fromMenuItem)
            
        case .showAlert    (let title, let message, let actionTitle, let action):
            self.showAlert(title: title, message: message, actionTitle: actionTitle, action: action)
            
        }
    }
}





// MARK: - Start main actions fileprivate
fileprivate extension Coordinator {
    
    
    // MARK: push
    func push(_ vc: UIViewController, on flow: Screens.FlowDestination, animated: Bool = true) {
        func push(on nav: CustomNavigationController) { self.pushOnMain(vc: vc, navCon: nav, animated: animated) }
        
        switch flow {
        case .anyTopLevel: return push(on: topExistNavigationLevel)
        case .authFlow   : return push(on: authFlowNavController)
        case .mainFlow   : break
        }
        guard let mainFlowNavController else {
            configMainFlowNavigation(with: vc)
            return self.presentOnMain(vc: mainFlowNavController!, navCon: authFlowNavController, animated: animated)
        }
        mainFlowNavController.pushViewController(vc, animated: animated)
    }
    
    // MARK: present
    func present(_ vc: UIViewController, animated: Bool = true) {
        DispatchQueue.main.async {
            self.topExistNavigationLevel.present(vc, animated: true)
        }
    }
    
    
    // MARK: popTill
    func popTill(_ vc: UIViewController, on flow: Screens.FlowDestination, animated: Bool = true) {
        let popTill: (UIViewController, CustomNavigationController?) -> Void = {
            guard let navController = $1 else { return }
            let (viewController, isExist) = self.isVCExist($0, on: navController)
            if !isExist { return }
            guard let viewController else { return }
            navController.popToViewController(viewController, animated: true)
        }
        
        switch flow {
        case .anyTopLevel: popTill(vc, topExistNavigationLevel)
        case .mainFlow   : popTill(vc, mainFlowNavController)
        case .authFlow   :
            checkForRemoveMainNavigationController()
            popTill(vc, authFlowNavController)
        }
        
    }
    
    
    
    // MARK: pushOrPopTo
    func pushOrPopTo(_ vc: UIViewController, on flow: Screens.FlowDestination, animated: Bool = true) {
        let pushOrPopTo: (UIViewController, UINavigationController) -> Void = {
            let (viewController, isExist) = self.isVCExist($0, on: $1)
            if     !isExist       { return self.pushOnMain   (vc: $0            , navCon: $1, animated: animated) }
            if let viewController { return self.popTillOnMain(vc: viewController, navCon: $1, animated: animated) }
        }
        
        let changeMainViewController: (UIViewController, UINavigationController) -> Void = {
            let (viewController, isExist) = self.isVCExist($0, on: $1)
            guard     isExist        else { return self.changeViewControllerOnMain(nav: $1, vc: $0) }
            guard let viewController else { return }
            return self.popTillOnMain(vc: viewController, navCon: $1, animated: animated)
        }
        
        do {
            let navigationController = try getNavigationController(vc, by: flow ,animated: animated)
            pushOrPopTo(vc, navigationController)
        } catch {
            if case NavigationErrors.needToChangeMenuItem(let navigationForChanges) = error { changeMainViewController(vc, navigationForChanges) }
            return
        }
        
    }
    
    
    // MARK: pop
    func pop(on flow: Screens.FlowDestination, animated: Bool = true) {
        switch flow {
        case .anyTopLevel: self.popOnMain(navCon: topExistNavigationLevel, animated: animated)
        case .authFlow   : self.popOnMain(navCon: authFlowNavController  , animated: animated)
        case .mainFlow   : self.popOnMain(navCon: mainFlowNavController  , animated: animated)
        }
    }
    
    // MARK: showAlert
    func showAlert(title: String, message: String, actionTitle: String, action: @escaping () -> Void) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.overrideUserInterfaceStyle = UDShared.instance.isWhiteMode ? .light : .dark
        alertVC.addAction(UIAlertAction(title: actionTitle, style: .default, action: action))
        self.move(as: .present(screen: .alert(alertVC)))
    }
    
    // MARK: showMenuAction
    func showMenuAction(fromItem: MenuItem) {
        if isMenuOpened { return }
        
        let topNavController: CustomNavigationController = topExistNavigationLevel
        let vc = CompositionRoot.sharedInstance.resolveMenuViewController(viewRect  : getMenuRect(),
                                                                          from      : fromItem     ,
                                                                          completion: { vc in hideMenu(vc: vc) })
        
        
        self.addChildOnMain(childVC: vc, to: topNavController.topViewController)
    
        showMenu(vc: vc)
        
        func showMenu(vc: UIViewController) {
            let mainAnimation: () -> Void = { topNavController.topViewController?.view.addSubview(vc.view) }
            let animationCompletion: (Bool) -> Void = { _ in
                UIView.animate(withDuration: 0.25) {
                    vc.view.frame.origin.x = 0
                    (vc as? MenuViewController)?.startShowViewAnimation()
                }
            }
            
            UIView.animate(withDuration: 0.25, animations: mainAnimation, completion: animationCompletion)
            isMenuOpened = true
        }
        
        func hideMenu(vc: UIViewController) {
            let mainAnimation: () -> Void = { vc.view.frame.origin.x = self.getStartXPosition() }
            let animationCompletion: (Bool) -> Void = { _ in
                UIView.animate(withDuration: 0.25,
                               animations: vc.view.removeFromSuperview) { _ in vc.removeFromParent() }
            }
            
            UIView.animate(withDuration: 0.25, animations: mainAnimation, completion: animationCompletion)
            isMenuOpened = false
            
        }
    }
    
}
// MARK: End main actions fileprivate -



// MARK: - Heplers
fileprivate extension Coordinator {
    
    func getNavigationController(_ vc: UIViewController, by flow: Screens.FlowDestination, animated: Bool = true) throws -> CustomNavigationController {
        // Select navigation controller for pop
        switch flow {
        case .anyTopLevel: return topExistNavigationLevel
        case .mainFlow   : break
        case .authFlow   :
            checkForRemoveMainNavigationController()
            return authFlowNavController
        }
        
        guard let mainFlowNavController else {
            configMainFlowNavigation(with: vc)
            authFlowNavController.present(mainFlowNavController!, animated: animated)
            throw NavigationErrors.mainNavigationWasPushed
        }
        
        if (vc as? ViewControllerIdentify)?.isOneOfMain == true,
           (mainFlowNavController.topViewController as? ViewControllerIdentify)?.isOneOfMain == true {
            throw NavigationErrors.needToChangeMenuItem(mainFlowNavController)
        }
        return mainFlowNavController
        
    }
    
    func configMainFlowNavigation(with rootVC: UIViewController) {
        mainFlowNavController = CustomNavigationController(rootViewController: rootVC)
        mainFlowNavController!.modalPresentationStyle = .overFullScreen
    }
    
    /// For check VC is exist
    /// - Returns: **(UIViewController?, isExist: Bool)** - if Bool true, UIViewController? always will be **not nil**
    func isVCExist(_ vc: UIViewController, on navController: UINavigationController) -> (UIViewController?, isExist: Bool) {
        let checkForConformation: (_ id: String, _ vc: UIViewController) -> Bool =  {
            let stackController = $1 as? (any ViewControllerIdentify)
            if let stackController, stackController.compareID(to: $0) { return true }
            return false
        }
        guard let vc = vc as? (any ViewControllerIdentify) else { return (nil, false) }
        
        let id = vc.viewControllerIdentificator
        for viewC in navController.viewControllers.reversed() {
            if checkForConformation(id, viewC) {
                return (viewC, true)
            }
        }
        
        return (nil, false)
    }
    
    func getStartXPosition() -> CGFloat {
        switch LanguageManager.shared.language.getDirection {
        case .rightToLeft:  return topExistNavigationLevel.view.bounds.width * 0.75
        case .leftToRight:  return topExistNavigationLevel.view.bounds.width * -0.75
        }
    }
    
    func getStartYPosition() -> CGFloat {
        return topExistNavigationLevel.navigationBar.intrinsicContentSize.height + UIApplication.safeAreaInsets.top
    }
    
    func getMenuRect() -> CGRect {
        // For correctly intrinsicContentSize
        let shadowHeight: CGFloat = 8
        let xPosition = getStartXPosition()
        let yPosition = getStartYPosition() - shadowHeight
        let width = topExistNavigationLevel.view.bounds.width
        let height = topExistNavigationLevel.view.bounds.height - topExistNavigationLevel.navigationBar.intrinsicContentSize.height - UIApplication.safeAreaInsets.top + shadowHeight
        return CGRect(x: xPosition, y: yPosition, width: width, height: height)
    }
    
}


// MARK: - Main thread helpers
fileprivate extension Coordinator {
    func presentOnMain(vc: UIViewController, navCon: UINavigationController, animated: Bool = true) {
        DispatchQueue.main.async { navCon.present(vc, animated: animated) }
    }
    
    func pushOnMain(vc: UIViewController, navCon: UINavigationController, animated: Bool = true) {
        DispatchQueue.main.async { navCon.pushViewController(vc, animated: animated) }
    }
    
    func popOnMain(navCon: UINavigationController?, animated: Bool = true) {
        DispatchQueue.main.async { navCon?.popViewController(animated: animated) }
    }
    
    func popTillOnMain(vc: UIViewController, navCon: UINavigationController, animated: Bool = true) {
        DispatchQueue.main.async { navCon.popToViewController(vc, animated: animated) }
    }
    
    /// Will push new view controller and remove from stack earlier view controller
    func changeViewControllerOnMain(nav: UINavigationController, vc: UIViewController, animated: Bool = true) {
        DispatchQueue.main.async {
            nav.pushViewController(vc, animated: true)
            nav.viewControllers[nav.viewControllers.count - 2].removeFromParent()
        }
    }
    
    func addChildOnMain(childVC: UIViewController, to vc: UIViewController?, animated: Bool = true) {
        DispatchQueue.main.async { vc?.addChild(childVC) }
    }
    
    
    func checkForRemoveMainNavigationController(animated: Bool = true) {
        DispatchQueue.main.async {
            guard let _ = self.mainFlowNavController else { return }
            self.mainFlowNavController?.dismiss(animated: animated)
            self.mainFlowNavController = nil
        }
    }
}
