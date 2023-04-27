import UIKit

extension UIBarButtonItem {
    func setTitle(strings: LocalizableStrings) {
        self.title = strings.localizedString
    }
    
    func useAsBackButton() {
        let image = LanguageManager.shared.language
            .getDirection
            .getNeededBetween(
                UIImage(systemName: "chevron.right"),
                UIImage(systemName: "chevron.left")
            )
        
        self.image = image
//        self.image(image, for: .normal, barMetrics: .default)
    }
}
