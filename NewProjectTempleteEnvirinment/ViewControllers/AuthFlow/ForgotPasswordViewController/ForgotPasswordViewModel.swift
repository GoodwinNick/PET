
import Foundation

class ForgotPasswordViewModel: BaseViewModel {
    weak var view: ForgotPasswordView?
    
    @objc dynamic var emailOrNickname: String = ""
    
    init(view: ForgotPasswordView) {
        self.view = view
        super.init()
    }
}

// MARK: - Actions
extension ForgotPasswordViewModel {
    func recoverPasswordAction() {
        let otpScreen: Screens = .otp(.emailConfirmation) {
            if $0 {
                self.coordinator.move(as: .pushOrPopTill(screen: .evidenceSection))
            } else {
                self.coordinator.move(as: .pop(flow: .anyTopLevel))
            }
        }
        coordinator.move(as: .push(screen: otpScreen))
    }
}
