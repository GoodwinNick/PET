
import Foundation

protocol LocalizableStrings {
    var string: String { get }
    var localizedString: String { get }
}

extension LocalizableStrings {
    var localizedString: String {
        return string.localize
    }
}

enum TextFieldStringType: String {
    case label       = ".label"
    case placeholder = ".placeholder"
}
