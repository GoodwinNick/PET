
import Foundation

class GeneralFlowStrings {
    static let stringsKey = "GeneralFlowStrings."

    
    enum CustomString: LocalizableStrings {
        
        case custom(_ message: String)
        
        var string: String {
            switch self {
            case .custom(let message): return message
            }
        }
        
        static func == (lhs: CustomString, rhs: CustomString) -> Bool {
            lhs.localizedString == rhs.localizedString
        }
    }
    
    // MARK: - General Strings
    enum GeneralString: String, LocalizableStrings {
        case english
        case ok
        case hours
        case done
        
        
        var string: String { GeneralFlowStrings.stringsKey + "GeneralString." + self.rawValue }
        
    }
    
    // MARK: Alerts
    enum Alert: LocalizableStrings {
        
        case cancel
        case error
        case tryAgain
        case somethingWentWrong
        case newPasswordsShoudBeSame
        case errorCode
        case foundUserAlert(name: String, code: String)
        case userNotFound
        case fillField(field: FieldsEmptyAlerts)
        
        // MARK: AlertStrings.FieldsEmptyAlerts
        enum FieldsEmptyAlerts: String, LocalizableStrings {
            case firstName
            case surname
            case idNo
            case pnoneNo
            case otpCode
            case login
            case email
            case password
            case passwordConfirmation
            
            var string: String { GeneralFlowStrings.stringsKey + "AlertStrings.FieldsEmptyAlerts." + rawValue }
        }
        
        var rawValue: String {
            switch self {
            case .cancel                  : return "cancel"
            case .error                   : return "Error"
            case .tryAgain                : return "tryAgain"
            case .somethingWentWrong      : return "somethingWentWrong"
            case .newPasswordsShoudBeSame : return "newPasswordsShoudBeSame"
            case .foundUserAlert          : return "foundUserAlert"
            case .userNotFound            : return "userNotFound"
            case .errorCode               : return "errorCode"
            case .fillField               : return "fillField"
            }
        }
        
        var localizedString: String {
            switch self {
            case .foundUserAlert(let name, let code):
                return string.localize.replacingOccurrences(of: "{name}", with: name).replacingOccurrences(of: "{code}", with: code)
                
            case .fillField(let field):
                return string.localize.replacingOccurrences(of: "{field}", with: field.localizedString)
                
            default:
                return string.localize
            }
        }
        
        var string: String { GeneralFlowStrings.stringsKey + "AlertStrings." + self.rawValue }
    }
    
    // MARK: OTPVC
    enum OTPVC: String, LocalizableStrings {
        case titlePhoneConfirmation
        case titleEmailConfirmation
        case confirmButton
        
        case wrongCode
        
        var string: String { GeneralFlowStrings.stringsKey + "OTPVC." + self.rawValue }

    }
    
}


