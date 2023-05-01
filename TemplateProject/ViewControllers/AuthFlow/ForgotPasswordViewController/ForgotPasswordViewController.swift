import UIKit

class ForgotPasswordViewController: BaseViewController<ForgotPasswordViewModel> {
    // MARK: - Properties
    @IBOutlet fileprivate weak var scrollView: UIScrollView!
    
    @IBOutlet fileprivate weak var emailOrNicknameLabel: UILabel!
    @IBOutlet fileprivate weak var emailOrNicknameTextField: UITextField!
    
    @IBOutlet fileprivate weak var recoverPasswordButton: UIButton!
    
    typealias LocalString = AuthFlowStrings.ForgotPasswordVC
}


// MARK: - Standard overriding
extension ForgotPasswordViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollForKeyboardChanges(scrollView)
        self.setTitle(strings: LocalString.title)
    }
}



// MARK: - Observation
extension ForgotPasswordViewController {
    override func bindWithObserver() {
        super.bindWithObserver()
        observer.from(emailOrNicknameTextField, \.text) .to { self.viewModel.emailOrNickname = $0 ?? "" }
    }
}

// MARK: - Actions
extension ForgotPasswordViewController {
    @IBAction func didTapRecoverPasswordButton(_ sender: UIButton) {
        viewModel.recoverPasswordAction()
    }
}

// MARK: - UI
extension ForgotPasswordViewController {
    override func configUI() {
        super.configUI()
        emailOrNicknameTextField.delegate = self
    }
    
    override func configStrings() {
        super.configStrings()
        emailOrNicknameLabel    .setLabelAttributedTitle  (LocalString.emailOrNickName(.label)      , .medi(size: 16, .labelText   ))
        emailOrNicknameTextField.configTextFieldAttributes(LocalString.emailOrNickName(.placeholder)                                )
        recoverPasswordButton   .setButtonAttributedTitle (LocalString.recoverPasswordButton        , .medi(size: 23, .bgButtonText))
        
    }
    
    override func configColors() {
        super.configColors()
        self.view.setBGColor(.background)
        recoverPasswordButton.config(bgColor: .buttonBackground, borderColor: .buttonBorder, borderWidth: 2, cornerRadius: 8)
        emailOrNicknameTextField.changeAppearance()
    }
}

// MARK: - UITextFieldDelegate
extension ForgotPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailOrNicknameTextField: emailOrNicknameTextField.resignFirstResponder()
        default: dismissKeyboard()
        }
        return true
    }
}


// MARK: - ForgotPasswordView
extension ForgotPasswordViewController: ForgotPasswordView {
    
}
