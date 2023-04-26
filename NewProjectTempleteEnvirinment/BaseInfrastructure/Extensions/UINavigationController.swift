import UIKit

extension UINavigationController {
    var isRoot: Bool {
        if viewControllers.count > 1 {
            return false
        } else {
            return true
        }
    }
}


extension UINavigationController {
    convenience init(screen: Screens) {
        self.init(rootViewController: screen.viewController)
    }
}
