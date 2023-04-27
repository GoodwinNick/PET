
import UIKit

class LoginViewModel: BaseViewModel {
    weak var view: LoginView?
    
    @objc dynamic var loginName: String = ""
    @objc dynamic var password : String = ""
    
    init(view: LoginView) {
        self.view = view
        super.init()
    }
}

// MARK: - Actions
extension LoginViewModel {
    func loginAction() {
        coordinator.move(as: .pushOrPopTill(screen: .main))
    }
    
    func registerAction() {
        coordinator.move(as: .pushOrPopTill(screen: .registration))
    }
    
    func forgotPasswordAction() {
       
        coordinator.move(as: .pushOrPopTill(screen: .forgotPassword))
    }
}
