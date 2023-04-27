import UIKit
import Photos

public protocol ImagePickerManagerProtocol: AnyObject {
    
    /// Did choosen or taken photo
    /// - Parameter image: optional image value
    @MainActor func didFinishPickingImage(image: UIImage?)
    
    
    /// For showing alerts
    /// - Parameter alert: Alert value to present
    @MainActor func showAlert(_ alert: UIAlertController)
    
    
    /// For show picker controller
    /// - Parameter imagePickerController: imagePickerController for present
    @MainActor func presentImagePicker(_ imagePickerController: UIImagePickerController)
}
