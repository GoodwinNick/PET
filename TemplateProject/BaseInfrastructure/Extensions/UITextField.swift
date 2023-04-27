import UIKit

extension UITextField {
    func set(_ text: String, with duration: TimeInterval) {
        DispatchQueue.main.async {
            UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve) {
                self.text = text
            }
        }
    }
    
    func setText(strings: LocalizableStrings) {
        self.text = strings.localizedString
    }
    
    func setPlaceholder(strings: LocalizableStrings) {
        self.placeholder = strings.localizedString
    }
    
}
