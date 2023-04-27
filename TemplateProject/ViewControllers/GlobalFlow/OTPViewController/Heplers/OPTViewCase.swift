import Foundation

enum OPTViewCase {
    case phoneConfirmation
    case emailConfirmation
    
    var digitsCount: Int {
        switch self {
        case .phoneConfirmation: return 4
        case .emailConfirmation: return 6
        }
    }
    
    var title: LocalizableStrings {
        switch self {
        case .phoneConfirmation:
            return GeneralFlowStrings.OTPVC.titlePhoneConfirmation
        case .emailConfirmation:
            return GeneralFlowStrings.OTPVC.titleEmailConfirmation
        }
    }
}
