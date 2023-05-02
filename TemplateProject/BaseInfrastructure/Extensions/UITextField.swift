import UIKit

extension UITextField {
    @MainActor func set(_ text: String, with duration: TimeInterval) async {
        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve) {
            self.text = text
        }
    }
    
    @MainActor func setText(strings: LocalizableStrings) async {
        self.text = strings.localizedString
    }
    
    @MainActor func setPlaceholder(strings: LocalizableStrings) async {
        self.placeholder = strings.localizedString
    }
    
}
