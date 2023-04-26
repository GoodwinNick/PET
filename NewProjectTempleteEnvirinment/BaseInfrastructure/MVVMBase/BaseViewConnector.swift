
import Foundation
import SVProgressHUD
import APIService

protocol BaseViewConnector: AnyObject {
    func showHUD()
    func hideHUD()
    func showErrorHUD(error: Error)
}

extension BaseViewConnector {
    func showHUD()  {
        DispatchQueue.main.async {
            SVProgressHUD.show()
        }
    }
    
    func hideHUD() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
    
    func showErrorHUD(error: Error) {
        DispatchQueue.main.async {
            let errorMessage: String
            if let error = error as? APIError {
                errorMessage = error.description
            } else {
                errorMessage = error.localizedDescription
            }
            SVProgressHUD.showError(withStatus: errorMessage)
        }
    }
    
}
