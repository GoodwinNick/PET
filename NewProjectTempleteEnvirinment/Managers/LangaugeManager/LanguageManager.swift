
import UIKit


class LanguageManager {
    
    static var shared = LanguageManager()

    fileprivate init() {
        self.language = UDShared.instance.language
    }
    
    var langID: String {
        return language.identifier
    }
    
    var language: Language = .english {
        didSet {
            UDShared.instance.language = language
            String.localizationBundle = nil
            
            Notifications.languageChanged.post()
        }
    }
    
    var getSemanticContent: UISemanticContentAttribute {
        switch language {
        case .english:
            return .forceLeftToRight
        }
    }
    
    var getTextAligmentDirection: NSTextAlignment {
        switch language {
        case .english:
            return .left
        }
    }
    
    func switchLanguage() {
        switch language {

        case .english: language = .english
        }
    }
}

enum Direction {
    case rightToLeft
    case leftToRight
    
    /// rightToLeft lang will return first item, leftToRight -> secondItem
    func getNeededBetween<T: Any>(_ rightToLeft: T, _ leftToRight: T) -> T {
        switch self {
        case .rightToLeft:
            return rightToLeft
            
        case .leftToRight:
            return leftToRight
        }
    }
}

enum Language: String {
    case english = "English"
    
    
    static func initWithId(_ id: String?) -> Language {
        switch id {
        case "en": return .english
        default: return .english
        }
    }
    
    /// Emoji of language
    var flagString: LocalizableStrings {
        switch self {
        case .english:
            return GeneralFlowStrings.CustomString.custom("🇬🇧")
        }
    }
    
    /// Laguage identifier
    var identifier: String {
        switch self {
        case .english:
            return "en"
        }
    }
    
    /// Direction of text
    var getDirection: Direction {
        switch self {
        case .english:
            return .leftToRight
            
        }
    }
}
