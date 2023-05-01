
import Foundation

enum CoordinatorAction {
    case push         (screen       : Screens                )
    case pushOrPopTill(screen       : Screens                )
    case present      (screen       : Screens                )
    case popTill      (screen       : Screens                )
    case pop          (flow         : Screens.FlowDestination)
    case showMenu     (fromMenuItem : MenuItem               )
    
    case showAlert(title: String, message: String, actionTitle: String, action: () -> Void)
    case showAlertTextField(title: String, message: String, confirmAction: (String) async -> Void, cancel: () async -> Void)
}
