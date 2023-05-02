import UIKit

extension UITextField {
    func set(_ text: String, with duration: TimeInterval) async {
        await MainActor.run {
            UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve) {
                self.text = text
            }
        }
    }
    
    func setText(strings: LocalizableStrings) async {
        await MainActor.run {
            self.text = strings.localizedString
        }
    }
    
    func setPlaceholder(strings: LocalizableStrings) async {
        await MainActor.run {
            self.placeholder = strings.localizedString
        }
    }
    
}
