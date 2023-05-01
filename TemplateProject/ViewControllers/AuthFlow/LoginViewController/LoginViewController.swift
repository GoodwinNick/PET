import UIKit

class LoginViewController: BaseViewController<LoginViewModel> {
    // MARK: - Properties declaration
    @IBOutlet fileprivate weak var loginTitleLabel   : UILabel!
    @IBOutlet fileprivate weak var registerTitleLabel: UILabel!
    
    @IBOutlet fileprivate weak var loginTextFeild    : UITextField!
    @IBOutlet fileprivate weak var passwordTextFeild : UITextField!

    @IBOutlet fileprivate weak var loginButton       : UIButton!
    @IBOutlet fileprivate weak var goToRegisterButton: UIButton!
    @IBOutlet fileprivate weak var forgotPassButton  : UIButton!
    
    @IBOutlet fileprivate weak var scrollView        : UIScrollView!
    
    typealias LocalStrings = AuthFlowStrings.LoginVC
    
}

// MARK: - Standard funcs overriding
extension LoginViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollForKeyboardChanges(scrollView)
        self.setTitle(strings: LocalStrings.title)
    }
}


// MARK: - Observation
extension LoginViewController {
    override func bindWithObserver() {
        super.bindWithObserver()
        observer.from(loginTextFeild   , \.text).to { self.viewModel.loginName = $0 ?? "" }
        observer.from(passwordTextFeild, \.text).to { self.viewModel.password  = $0 ?? "" }
        
    }
}

// MARK: - UI configurators
extension LoginViewController {
    override func configUI() {
        super.configUI()
        loginTextFeild   .delegate = self
        passwordTextFeild.delegate = self
    }
    
    override func configStrings() {
        super.configStrings()
        loginButton       .setButtonAttributedTitle (LocalStrings.loginButton           , .medi(size: 23, .bgButtonText  )                    )
        goToRegisterButton.setButtonAttributedTitle (LocalStrings.goToRegistrationButton, .medi(size: 14, .noBGButtonText)                    )
        forgotPassButton  .setButtonAttributedTitle (LocalStrings.forgotPasswordButton  , .medi(size: 14, .noBGButtonText), isUnderlined: true)
        loginTitleLabel   .setLabelAttributedTitle  (LocalStrings.username(.label)      , .medi(size: 16, .labelText     )                    )
        registerTitleLabel.setLabelAttributedTitle  (LocalStrings.password(.label)      , .medi(size: 16, .labelText     )                    )
        loginTextFeild    .configTextFieldAttributes(LocalStrings.username(.placeholder)                                                      )
        passwordTextFeild .configTextFieldAttributes(LocalStrings.password(.placeholder)                                                      )
    }
    
    override func configColors() {
        super.configColors()
        self.view.setBGColor(.background)
        self.view.backgroundColor = ColorManager.ColorCase.background.color
        loginTextFeild   .changeAppearance()
        passwordTextFeild.changeAppearance()
        
        loginButton.config(bgColor: .buttonBackground, borderColor: .buttonBorder, borderWidth: 2, cornerRadius: 8)
    }
}


// MARK: - Actions
extension LoginViewController {
    @IBAction func didTapLogin(_ sender: UIButton) {
        viewModel.loginAction()
    }
    
    @IBAction func didTapRegister(_ sender: UIButton) {
        viewModel.registerAction()
    }
    
    @IBAction func didTapForgotPassword(_ sender: UIButton) {
        viewModel.forgotPasswordAction()
    }
}

// MARK: - LoginView
extension LoginViewController: LoginView {
    
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case loginTextFeild   : passwordTextFeild.becomeFirstResponder()
        case passwordTextFeild: passwordTextFeild.resignFirstResponder()
            
        default:
            dismissKeyboard()
        }
        return true
    }
}
