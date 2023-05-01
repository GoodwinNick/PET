import UIKit

class RegistrationViewController: BaseViewController<RegistrationViewModel> {

    typealias LocalStrings = AuthFlowStrings.RegistrationVC
    
    
    // MARK: - Properties and outlets
    @IBOutlet fileprivate weak var usernameLabel             : UILabel!
    @IBOutlet fileprivate weak var nameLabel                 : UILabel!
    @IBOutlet fileprivate weak var surnameLabel              : UILabel!
    @IBOutlet fileprivate weak var genderLabel               : UILabel!
    @IBOutlet fileprivate weak var birthLabel                : UILabel!
    @IBOutlet fileprivate weak var emailLabel                : UILabel!
    @IBOutlet fileprivate weak var phoneLabel                : UILabel!
    @IBOutlet fileprivate weak var passLabel                 : UILabel!
    @IBOutlet fileprivate weak var passConformationLabel     : UILabel!
    
    @IBOutlet fileprivate weak var usernameTextField         : UITextField!
    @IBOutlet fileprivate weak var nameTextField             : UITextField!
    @IBOutlet fileprivate weak var surnameTextField          : UITextField!
    @IBOutlet fileprivate weak var genderTextField           : UITextField!
    @IBOutlet fileprivate weak var birthTextField            : UITextField!
    @IBOutlet fileprivate weak var emailTextField            : UITextField!
    @IBOutlet fileprivate weak var phoneTextField            : UITextField!
    @IBOutlet fileprivate weak var passTextField             : UITextField!
    @IBOutlet fileprivate weak var passConformationTextField : UITextField!
    
    @IBOutlet fileprivate weak var goToLoginButton           : UIButton!
    @IBOutlet fileprivate weak var registerButton            : UIButton!
    
    @IBOutlet fileprivate weak var confirmEmailButton        : UIButton!
    @IBOutlet fileprivate weak var confirmPhoneButton        : UIButton!
    
    @IBOutlet fileprivate weak var scrollView: UIScrollView!
    
    @IBOutlet fileprivate weak var pickerToolbar: UIToolbar!
    @IBOutlet fileprivate weak var nextToolbarButton: UIBarButtonItem!
    
    private let dateFormatter = DateFormatterManager.shared
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(onDateValueChanged(_:)), for: .valueChanged)
        return datePicker
    }()
    
    private lazy var genderPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()
    
    fileprivate var labelStringsList: [UILabel: LocalStrings] {
        [
            usernameLabel         : .username        (.label),
            nameLabel             : .name            (.label),
            surnameLabel          : .surname         (.label),
            genderLabel           : .gender          (.label),
            birthLabel            : .birthDate       (.label),
            emailLabel            : .email           (.label),
            phoneLabel            : .phoneNo         (.label),
            passLabel             : .pass            (.label),
            passConformationLabel : .passConformation(.label)
        ]
    }
    
    fileprivate var textFieldsList: [UITextField: LocalStrings] {
        [
            usernameTextField         : .username        (.placeholder),
            nameTextField             : .name            (.placeholder),
            surnameTextField          : .surname         (.placeholder),
            genderTextField           : .gender          (.placeholder),
            birthTextField            : .birthDate       (.placeholder),
            emailTextField            : .email           (.placeholder),
            phoneTextField            : .phoneNo         (.placeholder),
            passTextField             : .pass            (.placeholder),
            passConformationTextField : .passConformation(.placeholder)
        ]
    }
    
    
    fileprivate var genders: [String] = ["", "Male", "Female"]
}

// MARK: - Standard overriding
extension RegistrationViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollForKeyboardChanges(scrollView)
        self.setTitle(strings: LocalStrings.title)
    }
}

// MARK: - Actions
extension RegistrationViewController {
    @IBAction func confirmEmailTapped(_ sender: UIButton) {
        viewModel.confirmEmailAction()
    }
    
    @IBAction func confirmPhoneTapped(_ sender: UIButton) {
        viewModel.confirmPhoneAction()
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        viewModel.registerButtonAction()
    }
    
    @IBAction func goToLoginButtonTapped(_ sender: UIButton) {
        viewModel.goToLoginButtonAction()
    }
    
    
    @IBAction func onAccessoryViewDoneButtonTapped(_ sender: UIBarButtonItem) {
        if genderTextField.isFirstResponder {
            birthTextField.becomeFirstResponder()
            onDateValueChanged(self.datePicker)
        } else if birthTextField.isFirstResponder {
            emailTextField.becomeFirstResponder()
        } else if phoneTextField.isFirstResponder {
            passTextField.becomeFirstResponder()
        }
    }
    
    @objc private func onDateValueChanged(_ datePicker: UIDatePicker) {
        Task(priority: .background) {
            async let dateString: String? = self.dateFormatter.convert(from: .fromDate(datePicker.date), .birthDate)
            self.birthTextField.text = await dateString
            
        }
    }
    
}


// MARK: - Observation
extension RegistrationViewController {
    override func bindWithObserver() {
        super.bindWithObserver()
        observer.from(usernameTextField        , \.text).to { self.viewModel.username         = $0 ?? "" } 
        observer.from(nameTextField            , \.text).to { self.viewModel.name             = $0 ?? "" } 
        observer.from(surnameTextField         , \.text).to { self.viewModel.surname          = $0 ?? "" } 
        observer.from(genderTextField          , \.text).to { self.viewModel.gender           = $0 ?? "" } 
        observer.from(birthTextField           , \.text).to { self.viewModel.birth            = $0 ?? "" } 
        observer.from(emailTextField           , \.text).to { self.viewModel.email            = $0 ?? "" } 
        observer.from(phoneTextField           , \.text).to { self.viewModel.phone            = $0 ?? "" } 
        observer.from(passTextField            , \.text).to { self.viewModel.pass             = $0 ?? "" } 
        observer.from(passConformationTextField, \.text).to { self.viewModel.passConformation = $0 ?? "" } 
    }
}


// MARK: - UI
extension RegistrationViewController {
    override func configUI() {
        super.configUI()
        birthTextField .inputView = datePicker
        genderTextField.inputView = genderPicker
        
        birthTextField .inputAccessoryView = pickerToolbar
        genderTextField.inputAccessoryView = pickerToolbar
        phoneTextField .inputAccessoryView = pickerToolbar
    }
    
    override func configStrings() {
        super.configStrings()
        labelStringsList.forEach { self.configLabel    ($0, $1) }
        textFieldsList  .forEach { self.configTextField($0, $1) }
        
        goToLoginButton.setButtonAttributedTitle(LocalStrings.goToLoginButton, .medi(size: 14, .noBGButtonText))
        registerButton .setButtonAttributedTitle(LocalStrings.registerButton , .medi(size: 23, .bgButtonText))
        
        updateConfirmButtons()
    }
    
    override func configColors() {
        super.configColors()
        registerButton.config(bgColor: .buttonBackground, borderColor: .buttonBorder, borderWidth: 2, cornerRadius: 8)
        self.view.setBGColor(.background)
        datePicker   .changePickerAppearance()
        genderPicker .changePickerAppearance()
        pickerToolbar.changeAppearance()
        textFieldsList.forEach { TF, _ in TF.changeAppearance() }
    }
    
    
    // Helper function
    private func configLabel(_ label: UILabel, _ string: LocalStrings, _ font: String.FontStringType = .medi(size: 16, .labelText)) {
        label.setLabelAttributedTitle(string, font)
    }
    
    // Helper function
    private func configTextField(_ textField: UITextField, _ string: LocalStrings) {
        textField.configTextFieldAttributes(string)
        textField.delegate = self
        textField.textColor = ColorManager.ColorCase.textFieldText.color
    }
    
}

// MARK: - RegistrationView
extension RegistrationViewController: RegistrationView {
    func updateConfirmButtons() {
        confirmEmailButton.setButtonAttributedTitle(
            LocalStrings.confirmButton(viewModel.isConfirmedEmail),
            .medi(size: 14, .noBGButtonText)
        )
        confirmPhoneButton.setButtonAttributedTitle(
            LocalStrings.confirmButton(viewModel.isConfirmedPhone),
            .medi(size: 14, .noBGButtonText)
        )
    }
}


// MARK: - UITextFieldDelegate
extension RegistrationViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case usernameTextField         : nameTextField            .becomeFirstResponder()
        case nameTextField             : surnameTextField         .becomeFirstResponder()
        case surnameTextField          : genderTextField          .becomeFirstResponder()
        case genderTextField           : birthTextField           .becomeFirstResponder()
        case birthTextField            : emailTextField           .becomeFirstResponder()
        case emailTextField            : phoneTextField           .becomeFirstResponder()
        case phoneTextField            : passTextField            .becomeFirstResponder()
        case passTextField             : passConformationTextField.becomeFirstResponder()
        case passConformationTextField : passConformationTextField.resignFirstResponder()
            
        default: dismissKeyboard()
        }
        
        return true
    }
}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate
extension RegistrationViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextField.text = genders[row]
    }
    
}
