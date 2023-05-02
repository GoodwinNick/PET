import UIKit

class BaseViewController<T>: UIViewController where T: BaseViewModel {
    
    var observer = Observer()
    
    var viewModel: T!
    
    fileprivate var isViewConfigured: Bool = false
    var langManager: LanguageManager { return LanguageManager.shared }
    var coordinator: Coordinator     { return Coordinator.shared }
    var udIntent   : UDShared        { return UDShared.instance }
    
    weak var languageButton     : UIBarButtonItem?
    weak var apearenceModeButton: UIBarButtonItem?
    weak var backButton         : UIBarButtonItem?
    weak var leftMenuButton     : UIBarButtonItem?
    
    deinit { print("deinited with \(type(of: self))") }

    
    func set(viewModel: T) {
        self.viewModel = viewModel
    }
    
    
    
    
    // MARK: - Observations
    
    @objc open dynamic func bindWithObserver() async {}
    
    
    func configObservers() {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(configStrings),
            notifName: .languageChanged
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(configAppearance),
            notifName: .appearanceModeChanged
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForeground),
            notifName: .willEnterForegroundNotification
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didEnterBackground),
            notifName: .didEnterBackgroundNotification
        )
        
    }
    
    // MARK: Observation functions
    /// Calls  from notification changed language. Method for overriding,
    @objc open dynamic func configStrings() {
        clearBarItems()
        configBarItems()
    }
    
    @objc open dynamic func configAppearance() {
        self.navigationController?.setNeedsStatusBarAppearanceUpdate()
        self.configStrings()
        self.configColors()
        apearenceModeButton?.title = AppearanceModeManager.shared.currentMode.icon
        coordinator.updateNavAppearance()
    }
    
    @objc func willEnterForeground() {
        viewModel.willEnterForeground()
    }
    
    @objc func didEnterBackground() {
        viewModel.didEnterBackground()
    }
    
    
    
    
    // MARK: - UI
    /// Calls when viewDidLoad after force layout views. Method for overriding,
    @objc open dynamic func configUI() {
        
    }
    
    /// Calls when .appearanceModeChanged. Method for overriding,
    @objc open dynamic func configColors() {
        
    }
    
   
    
    // MARK: Bar buttons configuration
    @objc open dynamic func configBarMenuItem() {
        if self is MenuViewController { return }
        if !self.isOneOfMain { return }
        if coordinator.mainFlowNavController != nil {
            let menuBut = UIBarButtonItem(
                title: "",
                style: .plain,
                target: self,
                action: #selector(menuButtonAction)
            )
            menuBut.image = UIImage(systemName: "line.3.horizontal")
            leftMenuButton = menuBut
            self.navigationItem.leftBarButtonItem = menuBut
        }
    }
    
    
    @objc open dynamic func configApearenceButtonItem() -> UIBarButtonItem? {
        // MARK: Apearence Mode Button
        if self is CoordinatorViewController { return nil }
        if apearenceModeButton == nil {
            let apearenceModeBut = UIBarButtonItem(
                title: AppearanceModeManager.shared.currentMode.icon,
                style: .plain,
                target: self,
                action: #selector(switchApearenceMode)
            )
            apearenceModeButton = apearenceModeBut
            apearenceModeBut.width = 40
            return apearenceModeBut
        }
        return apearenceModeButton
    }
    
    @objc open dynamic func configBarItems() {
        if self is MenuViewController { return }
        var rightButtonsArray: [UIBarButtonItem] = []
        if let appearanceButton = configApearenceButtonItem() {
            rightButtonsArray.append(appearanceButton)
        }
        //        // MARK: Language Button
        //        if languageButton == nil {
        //            let langBut = UIBarButtonItem(
        //                title: langManager.language.flagString.localizedString,
        //                style: .plain,
        //                target: self,
        //                action: #selector(switchLanguage)
        //            )
        //            languageButton = langBut
        //            langBut.width = 40
        //            rightButtonsArray.append(langBut)
        //        }
        
        switch langManager.language.getDirection {
        case .rightToLeft:  self.navigationItem.rightBarButtonItems = rightButtonsArray.reversed()
        case .leftToRight:  self.navigationItem.rightBarButtonItems = rightButtonsArray
        }
        configBarMenuItem()
    }
    
    
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
   
    // MARK: Bar buttons actions
    /// Will pop view controller
    @objc func backButtonAction() {
        coordinator.move(as: .pop(flow: .anyTopLevel))
    }
    
    /// Will change apearence mode
    @objc func switchApearenceMode() {
        AppearanceModeManager.shared.switchMode()
    }
    
    /// Will change language
    @objc func switchLanguage() {
        langManager.switchLanguage()
    }
    
    
    /// Will show side menu
    @objc func menuButtonAction() {
        coordinator.move(as: .showMenu(fromMenuItem: menuItem))
    }
   
    
    
    
    // MARK: -  Start Standard overriding
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded with type \(type(of: self))")

        configObservers()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        if !isViewConfigured {
            self.view.layoutIfNeeded()
            configUI()
            configAppearance()
            isViewConfigured = true
        }
        
        viewModel.viewDidLoad()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        switch AppearanceModeManager.shared.currentMode {
        case .white: return .darkContent
        case .black: return .lightContent
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await bindWithObserver()
        }
        viewModel.viewWillAppear()
                
        reconfigNavigationBar()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewDidAppear()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.viewWillDisappear()
        observer.invalidateAll()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewDidDisappear()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel.viewDidLayoutSubviews()
    }
    
    // MARK: End Standard overriding -
    
}



// MARK: - Helpers
extension BaseViewController {
    /// For use main thread.
    /// - Parameters:
    ///   - seconds: optional if you wanna to do action after some time
    ///   - action: action which will be activated
    func asyncAfter(_ seconds: TimeInterval = 0, action: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: action)
    }
  
    
    
    // MARK: UI helpers
    private func clearBarItems() {
        if self is MenuViewController { return }
        leftMenuButton = nil
        apearenceModeButton = nil
        languageButton = nil
        backButton = nil

        self.navigationItem.leftBarButtonItems = []
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItems = []
        self.navigationItem.rightBarButtonItem = nil

        if #available(iOS 16.0, *) { self.navigationItem.centerItemGroups = [] }
    }

    func reconfigNavigationBar() {
        // For fix bug then title disappeared when we come back to screen
        let title = self.title
        self.title = ""
        self.title = title
        
        // Due to using addictional Coordinator view controller we need to manually change back button
        let navItems = self.navigationController?.viewControllers.filter  { !($0 is CoordinatorViewController) }

        if navItems?.count == 1 {
            self.navigationItem.setHidesBackButton(true, animated: false)
        } else {
            self.navigationItem.setHidesBackButton(false, animated: false)
        }

    }

    
    
}

// MARK: - ViewControllerIdentify
extension BaseViewController: ViewControllerIdentify {
   
    var viewControllerIdentificator: String {
        return "\(type(of: T.self))"
    }
    
    var isOneOfMain: Bool {
        if self is MainViewController || self is EvidenceSectionViewController {
            return true
        } else {
            return false
        }
    }
    
    var menuItem: MenuItem {
        switch self {
        case _ where self is MainViewController           : return .main
        case _ where self is EvidenceSectionViewController: return .evidence
        default:
            return .nonMenuCase
        }
    }
}





