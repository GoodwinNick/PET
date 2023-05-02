
import UIKit

extension UILabel {
    @MainActor func set(_ text: String, with duration: TimeInterval) async {
        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve) {
            self.text = text
        }
    }
    
    @MainActor func setTitle(strings: LocalizableStrings) {
        self.text = strings.localizedString
    }
}
