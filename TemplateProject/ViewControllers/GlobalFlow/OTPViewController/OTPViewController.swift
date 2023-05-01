import UIKit

class OTPViewController: BaseViewController<OTPViewModel> {
   
    typealias LocalStrings = GeneralFlowStrings.OTPVC
    
    // MARK: - Properties and outlets
    @IBOutlet weak var otpCodeTextField: AEOTPTextField!
    @IBOutlet weak var confirmButton   : UIButton!
    @IBOutlet weak var scrollView      : UIScrollView!
    
    
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(didTapOnTextField))
        return gesture
    }()
    
}



// MARK: - Standard overriding
extension OTPViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollForKeyboardChanges(scrollView)
        self.setTitle(strings: viewModel.otpCase.title)
    }
    
}


// MARK: - Observartions
extension OTPViewController {
    
    override func bindWithObserver() {
        super.bindWithObserver()
        observer.from(otpCodeTextField, \.text).to { print($0 ?? "") }
    }
    
}


// MARK: - Actions
extension OTPViewController {
    
    @objc func didTapOnTextField() {
        otpCodeTextField.clearOTP()
        otpCodeTextField.becomeFirstResponder()
    }
 
    @IBAction func didTapConfirmButton(_ sender: UIButton) {
        viewModel.confirmButtonTapped()
    }
    
}


// MARK: - UI
extension OTPViewController {
    
    override func configUI() {
        super.configUI()
        otpCodeTextField.otpDelegate = self
        otpCodeTextField.configure(with: viewModel.otpCase.digitsCount)
        otpCodeTextField.becomeFirstResponder()
        otpCodeTextField.addGestureRecognizer(tapRecognizer)
    }
    
    override func configStrings() {
        super.configStrings()
        confirmButton.setButtonAttributedTitle(LocalStrings.confirmButton, .medi(size: 23, .bgButtonText))
    }
    
    override func configColors() {
        super.configColors()
        
        otpCodeTextField.updateAppearance()
        self.view.setBGColor(.background)
        confirmButton.config(bgColor: .buttonBackground, borderColor: .buttonBorder, borderWidth: 2, cornerRadius: 8)
    }
    
}

// MARK: - OTPView
extension OTPViewController: OTPView {
    func clearOTPField() {
        
    }
}

// MARK: - AEOTPTextFieldDelegate
extension OTPViewController: AEOTPTextFieldDelegate {
    func didUserFinishEnter(the code: String) {
        viewModel.code = code
        dismissKeyboard()
    }
    
    
}
