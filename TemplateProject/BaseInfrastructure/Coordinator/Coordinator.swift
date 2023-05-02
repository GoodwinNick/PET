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
        Task(priority: .background) {
            switch action {
            case .pushOrPopTill   (let vc  ): await self.pushOrPopTo(vc.viewController, on: vc.flowDestination)
            case .push            (let vc  ): await self.push       (vc.viewController, on: vc.flowDestination)
            case .present         (let vc  ): await self.present    (vc.viewController                        )
            case .popTill         (let vc  ): await self.popTill    (vc.viewController, on: vc.flowDestination)
            case .pop             (let flow): await self.pop        (                   on: flow              )
            case .showMenu(let fromMenuItem): await self.showMenuAction(fromItem: fromMenuItem)
                
            case .showAlert(let title, let message, let actionTitle, let action):
                await self.showAlert(title, message, actionTitle, action)
             
            case .showAlertTextField(let title, let message, let confirmAction, let cancel):
                await self.showAlertTextField(title, message, confirmAction, cancel)
            }
        }
    }
}





// MARK: - Start main actions fileprivate
fileprivate extension Coordinator {
    
    func showAlertTextField(_ title: String, _ message: String, _ confirmAction: @escaping (String) async -> Void, _ cancelAction: @escaping () async -> Void) async {
        let alertController: UIAlertController = await UIAlertController(title: title, message: message, preferredStyle: .alert)
        await MainActor.run {
            alertController.addTextField { $0.text = "rtmp://192.168.31.167:1935/live" }
        }
        let confirmAction = await UIAlertAction(title: "Confirm", style: .default) {
            await confirmAction(await alertController.textFields?.first?.text ?? "")
        }
        let cancelAction = await UIAlertAction(title: "Cancel", style: .cancel) { await cancelAction() }
        
        await alertController.addAction(confirmAction)
        await alertController.addAction(cancelAction)
        await self.present(alertController)
        
    }
    
    // MARK: push
    func push(_ vc: UIViewController, on flow: Screens.FlowDestination, animated: Bool = true) async {
        func push(on nav: CustomNavigationController) async { await self.pushOnMain(vc: vc, navCon: nav, animated: animated) }
        
        switch flow {
        case .anyTopLevel: return await push(on: topExistNavigationLevel)
        case .authFlow   : return await push(on: authFlowNavController)
        case .mainFlow   : break
        }
        guard let mainFlowNavController else {
            return await self.presentOnMain(
                vc: await configMainFlowNavigation(with: vc),
                navCon: authFlowNavController,
                animated: animated
            )
        }
        await pushOnMain(vc: vc, navCon: mainFlowNavController, animated: animated)
    }
    
    // MARK: present
    func present(_ vc: UIViewController, animated: Bool = true) async {
            await self.presentOnMain(vc: vc, navCon: topExistNavigationLevel, animated: animated)
        
    }
    
    
    // MARK: popTill
    func popTill(_ vc: UIViewController, on flow: Screens.FlowDestination, animated: Bool = true) async {
        let popTill: (UIViewController, CustomNavigationController?) async -> Void = {
            guard let navController = $1 else { return }
            let (viewController, isExist) = await self.isVCExist($0, on: navController)
            guard isExist, let viewController else { return }
            await self.popTillOnMain(vc: viewController, navCon: navController, animated: animated)
        }
        
        switch flow {
        case .anyTopLevel: await popTill(vc, topExistNavigationLevel)
        case .mainFlow   : await popTill(vc, mainFlowNavController)
        case .authFlow   :
            await checkForRemoveMainNavigationController()
            await popTill(vc, authFlowNavController)
        }
        
    }
    
    
    
    // MARK: pushOrPopTo
    func pushOrPopTo(_ vc: UIViewController, on flow: Screens.FlowDestination, animated: Bool = true) async {
        let pushOrPopTo: (UIViewController, UINavigationController) async -> Void = {
            let (viewController, isExist) = await self.isVCExist($0, on: $1)
            if     !isExist       { return await self.pushOnMain   (vc: $0            , navCon: $1, animated: animated) }
            if let viewController { return await self.popTillOnMain(vc: viewController, navCon: $1, animated: animated) }
        }
        
        let changeMainViewController: (UIViewController, UINavigationController) async -> Void = {
            let (viewController, isExist) = await self.isVCExist($0, on: $1)
            guard     isExist        else { return await self.changeViewControllerOnMain(nav: $1, vc: $0) }
            guard let viewController else { return }
            return await self.popTillOnMain(vc: viewController, navCon: $1, animated: animated)
        }
        
        do {
            let navigationController = try await getNavigationController(vc, by: flow ,animated: animated)
            await pushOrPopTo(vc, navigationController)
        } catch {
            if case NavigationErrors.needToChangeMenuItem(let navigationForChanges) = error {
                    await changeMainViewController(vc, navigationForChanges)
            }
            return
        }
        
    }
    
    
    // MARK: pop
    func pop(on flow: Screens.FlowDestination, animated: Bool = true) async {
        switch flow {
        case .anyTopLevel: await self.popOnMain(navCon: topExistNavigationLevel, animated: animated)
        case .authFlow   : await self.popOnMain(navCon: authFlowNavController  , animated: animated)
        case .mainFlow   : await self.popOnMain(navCon: mainFlowNavController  , animated: animated)
        }
    }
    
    // MARK: showAlert
    func showAlert(_ title: String, _ message: String, _ actionTitle: String, _ action: @escaping () -> Void) async {
        await MainActor.run {
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertVC.overrideUserInterfaceStyle = UDShared.instance.isWhiteMode ? .light : .dark
            alertVC.addAction(UIAlertAction(title: actionTitle, style: .default, action: action))
            self.move(as: .present(screen: .alert(alertVC)))
        }
    }
    
    // MARK: showMenuAction
    func showMenuAction(fromItem: MenuItem) async {
        if isMenuOpened { return }
        
        let topNavController: CustomNavigationController = topExistNavigationLevel
        var vc: MenuViewController?
        vc = await CompositionRoot.sharedInstance.resolveMenuViewController(
            viewRect  : getMenuRect(),
            from      : fromItem     ,
            completion: { [weak self] in
                self?.isMenuOpened = false
            }
        )
        
        await self.addChildOnMain(childVC: vc!, to: topNavController.topViewController)
    
        
        await MainActor.run { [weak vc] in
            UIView.animate(
                withDuration: 0.25,
                animations: { if let vc { topNavController.topViewController?.view.addSubview(vc.view) } },
                completion: { _ in
                    UIView.animate(withDuration: 0.25) { [weak vc] in
                        vc?.view.frame.origin.x = 0
                        vc?.startShowViewAnimation()
                    }
                }
            )
            self.isMenuOpened = true
        }
        
    }
    
}
// MARK: End main actions fileprivate -



// MARK: - Heplers
fileprivate extension Coordinator {
    
    func getNavigationController(_ vc: UIViewController, by flow: Screens.FlowDestination, animated: Bool = true) async throws -> CustomNavigationController {
        // Select navigation controller for pop
        switch flow {
        case .anyTopLevel: return topExistNavigationLevel
        case .mainFlow   : break
        case .authFlow   :
            await checkForRemoveMainNavigationController()
            return authFlowNavController
        }
        
        guard let mainFlowNavController else {
            await presentOnMain(vc: await self.configMainFlowNavigation(with: vc),
                                navCon: authFlowNavController,
                                animated: animated)
            throw NavigationErrors.mainNavigationWasPushed
        }
        
        let isTopControllerMain: Bool = await MainActor.run {
            (mainFlowNavController.topViewController as? ViewControllerIdentify)?.isOneOfMain == true
        }
        let isVCMain = (vc as? ViewControllerIdentify)?.isOneOfMain == true
        
        if isVCMain && isTopControllerMain {
            throw NavigationErrors.needToChangeMenuItem(mainFlowNavController)
        }
        return mainFlowNavController
        
    }
    
    func configMainFlowNavigation(with rootVC: UIViewController) async -> CustomNavigationController {
        return await MainActor.run {
            self.mainFlowNavController = CustomNavigationController(rootViewController: rootVC)
            self.mainFlowNavController!.modalPresentationStyle = .overFullScreen
            return mainFlowNavController!
        }
    }
    
    /// For check VC is exist
    /// - Returns: **(UIViewController?, isExist: Bool)** - if Bool true, UIViewController? always will be **not nil**
    func isVCExist(_ vc: UIViewController, on navController: UINavigationController) async -> (UIViewController?, isExist: Bool) {
        let checkForConformation: (_ id: String, _ vc: UIViewController) -> Bool =  {
            let stackController = $1 as? (any ViewControllerIdentify)
            if let stackController, stackController.compareID(to: $0) { return true }
            return false
        }
        guard let vc = vc as? (any ViewControllerIdentify) else { return (nil, false) }
        
        let id = vc.viewControllerIdentificator
        for viewC in await navController.viewControllers.reversed() {
            if checkForConformation(id, viewC) {
                return (viewC, true)
            }
        }
        
        return (nil, false)
    }
    
    /// Start X position for menuViewController
    func getStartXPosition() async -> CGFloat {
        switch LanguageManager.shared.language.getDirection {
        case .rightToLeft:  return await MainActor.run { topExistNavigationLevel.view.bounds.width *  0.75 }
        case .leftToRight:  return await MainActor.run { topExistNavigationLevel.view.bounds.width * -0.75 }
        }
        
    }
    
    /// Start Y position for menuViewController
    func getStartYPosition() async -> CGFloat {
        return await MainActor.run {
            return topExistNavigationLevel.navigationBar.intrinsicContentSize.height + UIApplication.safeAreaInsets.top
        }
    }
    
    /// Rect for menu view controller
    func getMenuRect() async -> CGRect {
        // For correctly intrinsicContentSize
        let shadowHeight                    : CGFloat = CustomNavigationController.shadowHeight
        async let intrinsicContentSizeHeight: CGFloat = MainActor.run { topExistNavigationLevel.navigationBar.intrinsicContentSize.height } + shadowHeight
        async let topNavBounds              : CGRect  = MainActor.run { topExistNavigationLevel.topViewController?.view.bounds ?? .zero }

        async let xPosition = getStartXPosition()
        async let yPosition = getStartYPosition() - shadowHeight
        
        let width  = await topNavBounds.width
        let height = await topNavBounds.height - intrinsicContentSizeHeight
        return CGRect(x: await xPosition, y: await yPosition, width: width, height: height)
    }
    
}


// MARK: - Main thread helpers
fileprivate extension Coordinator {
    
    func asyncOnMain(delay: CGFloat = 0, action: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { action() }
    }
    
    func onMainActor<T: Sendable>(actionForExecute: () -> T) async -> T {
        return await MainActor.run {
            return actionForExecute()
        }
    }
    
    /// Will present specified vc on specified navigation controller on **main thread**
    /// - Parameters:
    ///   - preAction: Can be used it before action we need to do some on **main thread**
    func presentOnMain(
        vc: UIViewController,
        navCon: UINavigationController,
        animated: Bool = true,
        preAction: @escaping () -> Void = { }
    ) async {
        await MainActor.run {
            preAction()
            navCon.present(vc, animated: animated)
        }
    }
    
    /// Will push specified vc on specified navigation controller on **main thread**
    /// - Parameters:
    ///   - preAction: Can be used it before action we need to do some on **main thread**
    func pushOnMain(
        vc: UIViewController,
        navCon: UINavigationController,
        animated: Bool = true,
        preAction: @escaping () -> Void = { }
    ) async {
        await MainActor.run {
            preAction()
            navCon.pushViewController(vc, animated: animated)
        }
    }
    
    /// Will pop vc on specified navigation controller on **main thread**
    /// - Parameters:
    ///   - preAction: Can be used it before action we need to do some on **main thread**
    func popOnMain(
        navCon: UINavigationController?,
        animated: Bool = true,
        preAction: @escaping () -> Void = { }
    ) async {
        await MainActor.run {
            preAction()
            navCon?.popViewController(animated: animated)
        }
    }
    
    /// Will pop till specified vc on specified navigation controller on **main thread**
    /// - Parameters:
    ///   - preAction: Can be used it before action we need to do some on **main thread**
    func popTillOnMain(
        vc: UIViewController,
        navCon: UINavigationController,
        animated: Bool = true,
        preAction: @escaping () -> Void = { }
    ) async {
        await MainActor.run {
            preAction()
            navCon.popToViewController(vc, animated: animated)
        }
    }
    
    /// Will push new view controller and remove from stack earlier view controller
    /// - Parameters:
    ///   - preAction: Can be used it before action we need to do some on **main thread**
    func changeViewControllerOnMain(
        nav: UINavigationController,
        vc: UIViewController, animated: Bool = true,
        preAction: @escaping () -> Void = { }
    ) async {
        await MainActor.run {
            preAction()
            nav.pushViewController(vc, animated: true)
            nav.viewControllers[nav.viewControllers.count - 2].removeFromParent()
        }
    }
    
    /// Will add specified childVC to VC on **main thread**
    /// - Parameters:
    ///   - preAction: Can be used it before action we need to do some on **main thread**
    func addChildOnMain(
        childVC: UIViewController,
        to vc: UIViewController?,
        animated: Bool = true,
        preAction: @escaping () -> Void = { }
    ) async {
        await MainActor.run { [weak childVC] in
            if let childVC {
                preAction()
                vc?.addChild(childVC)
            }
        }
    }
    
    
    /// Will check is it possible to remove main navigation flow controller and remove it on main thread
    /// - Parameters:
    ///   - preAction: Can be used it before action we need to do some on** main thread**
    func checkForRemoveMainNavigationController(
        animated: Bool = true,
        preAction: @escaping () -> Void = { }
    ) async {
        await MainActor.run {
            preAction()
            guard let _ = self.mainFlowNavController else { return }
            self.mainFlowNavController?.dismiss(animated: animated)
            self.mainFlowNavController = nil
        }
    }
}
