import UIKit

enum UserDefaultsValues: String {
    case isFirstOpen          = "isFirstOpen"
    case isLoggedIn           = "isLoggedIn"
    case isBiometricalAllowed = "isBiometricalAllowed"
    case language             = "language"
    case isWhiteMode          = "isWhiteMode"
    
}

let UD = UserDefaults.standard

class UDShared {
    
    static let instance = UDShared()
    
    fileprivate init() { }
    
    var isWhiteMode: Bool {
        get { return UD.getOptionalBool(by: .isWhiteMode) ?? false }
        set { UD.set(value: newValue, for: .isWhiteMode) }
    }
    
    var isFirstOpen: Bool {
        get { return UD.getOptionalBool(by: .isFirstOpen) ?? true }
        set { UD.set(value: newValue, for: .isFirstOpen) }
    }
    
    var isLoggedIn: Bool {
        get { return UD.getOptionalBool(by: .isLoggedIn) ?? false }
        set { UD.set(value: newValue, for: .isLoggedIn) }
    }
    
    var isBiometricalAllowed: Bool {
        get { return UD.getOptionalBool(by: .isBiometricalAllowed) ?? false }
        set { UD.set(value: newValue, for: .isBiometricalAllowed) }
    }
    
    var language: Language {
        get {
            let langId = UD.getOptionalString(by: .language)
            return Language.initWithId(langId)
        }
        set(value) {
            UD.set(value: value.identifier, for: .language)
        }
    }
    
}
