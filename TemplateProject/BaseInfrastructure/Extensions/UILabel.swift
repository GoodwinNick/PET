
import UIKit

extension UILabel {
    func set(_ text: String, with duration: TimeInterval) async {
        await MainActor.run {
            UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve) {
                self.text = text
            }
        }
    }
    
    func setTitle(strings: LocalizableStrings) {
        self.text = strings.localizedString
    }
}
