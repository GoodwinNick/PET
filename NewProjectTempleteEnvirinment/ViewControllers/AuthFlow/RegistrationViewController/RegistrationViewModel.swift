import UIKit

class RegistrationViewModel: BaseViewModel {
    weak var view: RegistrationView?
    
    @objc dynamic var username        : String = ""
    @objc dynamic var name            : String = ""
    @objc dynamic var surname         : String = ""
    @objc dynamic var gender          : String = ""
    @objc dynamic var birth           : String = ""
    @objc dynamic var email           : String = "" {
        didSet {
            isConfirmedEmail = (email == confirmedEmailValue)
        }
    }
    @objc dynamic var phone           : String = "" {
        didSet {
            isConfirmedPhone = (phone == confirmedPhoneValue)
        }
    }
    @objc dynamic var pass            : String = ""
    @objc dynamic var passConformation: String = ""
   
    var isConfirmedEmail = false {
        didSet {
            if isConfirmedEmail {
                confirmedEmailValue = email
            }
            view?.updateConfirmButtons()
        }
    }
    var isConfirmedPhone = false {
        didSet {
            if isConfirmedPhone {
                confirmedPhoneValue = phone
            }
            view?.updateConfirmButtons()
        }
    }
    
    private var confirmedEmailValue: String?
    private var confirmedPhoneValue: String?
    
    init(view: RegistrationView) {
        self.view = view
    }
}

// MARK: - Actions
extension RegistrationViewModel {
    func goToLoginButtonAction() {
        coordinator.move(as: .pushOrPopTill(screen: .login))
    }
    
    func registerButtonAction() {
        print(username, name, surname, gender, birth, email, phone, pass, passConformation)
    }
    
    func confirmEmailAction() {
        if self.isConfirmedEmail { return }
        let completeAction: (Bool) -> Void = {
            self.isConfirmedEmail = $0
            self.view?.updateConfirmButtons()
        }
        coordinator.move(as: .push(screen: .otp(.emailConfirmation, completion: completeAction)))
    }
    
    func confirmPhoneAction() {
        if self.isConfirmedPhone { return }
        let completeAction: (Bool) -> Void = {
            self.isConfirmedPhone = $0
            self.view?.updateConfirmButtons()
        }
        coordinator.move(as: .push(screen: .otp(.phoneConfirmation, completion: completeAction)))
    }
    
    
}
