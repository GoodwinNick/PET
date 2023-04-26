
import Foundation

enum NavigationErrors: Error {
    case needToChangeMenuItem(_ navigationForChange: CustomNavigationController)
    case mainNavigationWasPushed
}
