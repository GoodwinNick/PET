import Foundation

class AuthFlowStrings {
    static let stringsKey = "AuthFlowStrings."
    
    // MARK: LoginVC
    enum LoginVC: LocalizableStrings {
        
        case title
        case username(_ type: TextFieldStringType)
        case password(_ type: TextFieldStringType)
        case loginButton
        case goToRegistrationButton
        case forgotPasswordButton
        
        var string: String { AuthFlowStrings.stringsKey + "LoginVC." + self.rawValue }
        
        var rawValue: String {
            switch self {
            case .title                  : return "title"
                
            case .username(let type)     : return "username" + type.rawValue
            case .password(let type)     : return "password" + type.rawValue
            case .loginButton            : return "loginButton"
            case .goToRegistrationButton : return "goToRegistrationButton"
            case .forgotPasswordButton   : return "forgotPasswordButton"
                
            }
        }
    }
    
    // MARK: RegistrationVC
    enum RegistrationVC: LocalizableStrings {
        case title
        case goToLoginButton
        case registerButton
        
        case username        (_ type: TextFieldStringType)
        case name            (_ type: TextFieldStringType)
        case surname         (_ type: TextFieldStringType)
        case gender          (_ type: TextFieldStringType)
        case birthDate       (_ type: TextFieldStringType)
        case email           (_ type: TextFieldStringType)
        case phoneNo         (_ type: TextFieldStringType)
        case pass            (_ type: TextFieldStringType)
        case passConformation(_ type: TextFieldStringType)
        
        case confirmButton (_ isConfirmed: Bool)
        
        var string: String { AuthFlowStrings.stringsKey + "RegistrationVC." + self.rawValue }
        
        var rawValue: String {
            switch self {
            case .title                     : return "title"
            case .goToLoginButton           : return "goToLoginButton"
            case .registerButton            : return "registerButton"
                
            case .username        (let type): return "username"         + type.rawValue
            case .name            (let type): return "name"             + type.rawValue
            case .surname         (let type): return "surname"          + type.rawValue
            case .gender          (let type): return "gender"           + type.rawValue
            case .birthDate       (let type): return "birthDate"        + type.rawValue
            case .email           (let type): return "email"            + type.rawValue
            case .phoneNo         (let type): return "phoneNo"          + type.rawValue
            case .pass            (let type): return "pass"             + type.rawValue
            case .passConformation(let type): return "passConformation" + type.rawValue
            case .confirmButton(let isConfirmed):
                return "confirmButton." + (isConfirmed ? "confirmed" : "notConfirmed")
            }
            //
        }
    }
    
    
    // MARK: ForgotPasswordVC
    enum ForgotPasswordVC: LocalizableStrings {
        case title
        case emailOrNickName(_ type: TextFieldStringType)
        case recoverPasswordButton
        
        var string: String { AuthFlowStrings.stringsKey + "ForgotPasswordVC." + self.rawValue }
        
        var rawValue: String {
            switch self {
            case .title                     : return "title"
            case .emailOrNickName(let type) : return "emailOrNickName" + type.rawValue
            case .recoverPasswordButton     : return "recoverPasswordButton"
            }
        }
        
    }
    
}
