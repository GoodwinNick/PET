
import UIKit

class CustomNavigationController: UINavigationController {

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        configNawAppearance()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configNawAppearance()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: AppearanceModeManager.shared.currentMode.icon,
            style: .plain,
            target: self,
            action: #selector(changeAppearance)
        )
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        switch AppearanceModeManager.shared.currentMode {
        case .white: return .darkContent
        case .black: return .lightContent
        }
    }
    
    fileprivate func configNawAppearance() {
        let navigationBarAppearance: UINavigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        
        navigationBarAppearance.backgroundColor = ColorManager.ColorCase.navigationBackgroung.color
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : ColorManager.ColorCase.navigationTitle.color]
        
//        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        self.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        self.navigationBar.standardAppearance = navigationBarAppearance
        self.navigationBar.compactAppearance = navigationBarAppearance
        
        UINavigationBar.appearance().barTintColor = ColorManager.ColorCase.navigationTitle.color
        UINavigationBar.appearance().tintColor = ColorManager.ColorCase.navigationTitle.color
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : ColorManager.ColorCase.navigationTitle.color]
        UINavigationBar.appearance().backgroundColor = ColorManager.ColorCase.navigationBackgroung.color
//
//        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
//        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
//        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
//        
        self.navigationBar.shadow(offset: .init(width: 0, height: 8), radius: 4, color: ColorManager.ColorCase.shadow.color)
        self.navigationBar.backgroundColor = ColorManager.ColorCase.navigationBackgroung.color
        self.navigationBar.tintColor = ColorManager.ColorCase.navigationTitle.color
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : ColorManager.ColorCase.navigationTitle.color]

        self.addBottomBorder()
    }
    
    @objc func changeAppearance() {
        AppearanceModeManager.shared.switchMode()
    }
    
    func updateAppearance() {
        configNawAppearance()
    }
    
    
}
