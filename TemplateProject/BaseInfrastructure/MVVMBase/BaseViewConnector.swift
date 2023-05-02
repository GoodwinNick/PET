
import Foundation
import SVProgressHUD
import APIService

protocol BaseViewConnector: AnyObject {
    @MainActor func showHUD()
    @MainActor func hideHUD()
    @MainActor func showErrorHUD(error: Error)
}

extension BaseViewConnector {
    @MainActor func showHUD() {
        SVProgressHUD.show()
    }
    
    @MainActor func hideHUD() {
        SVProgressHUD.dismiss()
    }
    
    @MainActor func showErrorHUD(error: Error) {
        let errorMessage: String
        if let error = error as? APIError {
            errorMessage = error.description
        } else {
            errorMessage = error.localizedDescription
        }
        SVProgressHUD.showError(withStatus: errorMessage)
    }
    
}
