import UIKit

class OTPViewModel: BaseViewModel {
    weak var view: OTPView?
    let otpCase: OPTViewCase
    let completion: (Bool) -> Void
    
    @objc dynamic var code: String = ""
    
    init(view: OTPView, otpCase: OPTViewCase, completion: @escaping (Bool) -> Void) {
        self.view = view
        self.otpCase = otpCase
        self.completion = completion
        super.init()
    }
    
}

// MARK: - Actions
extension OTPViewModel {
    func confirmButtonTapped() {
        if code.count == otpCase.digitsCount,
            code == "\(Character.UnicodeScalarView(repeating: "0", count: otpCase.digitsCount))" {
            self.coordinator.move(as: .pop(flow: .anyTopLevel))
            completion(true)
        } else {
            self.coordinator.move(as: .showAlert(title: "Error", message: GeneralFlowStrings.OTPVC.wrongCode.localizedString, actionTitle: "Ok", action: { }))
            completion(false)
        }
    }
}
