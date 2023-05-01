
import UIKit

class CustomNavigationController: UINavigationController {

    static let shadowHeight: CGFloat = 8
    
    typealias Color = ColorManager.ColorCase
    
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
        
        navigationBarAppearance.backgroundColor     = Color.navigationBackgroung.color
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : Color.navigationTitle.color]
        
        self.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        self.navigationBar.standardAppearance   = navigationBarAppearance
        self.navigationBar.compactAppearance    = navigationBarAppearance
        
        
        UINavigationBar.appearance().barTintColor        = Color.navigationTitle.color
        UINavigationBar.appearance().tintColor           = Color.navigationTitle.color
        UINavigationBar.appearance().backgroundColor     = Color.navigationBackgroung.color
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : Color.navigationTitle.color]
        
        self.navigationBar.shadow(
            offset: .init(width: 0, height: CustomNavigationController.shadowHeight),
            radius: 4,
            color: Color.shadow.color
        )
        self.navigationBar.backgroundColor     = Color.navigationBackgroung.color
        self.navigationBar.tintColor           = Color.navigationTitle.color
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : Color.navigationTitle.color]

        self.addBottomBorder()
    }
    
    @objc func changeAppearance() {
        AppearanceModeManager.shared.switchMode()
    }
    
    func updateAppearance() {
        configNawAppearance()
    }
    
    
}
