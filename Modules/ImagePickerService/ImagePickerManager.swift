import UIKit
import AVFoundation
import Photos

public final class ImagePickerManager: NSObject {

   public weak var delegate: ImagePickerManagerProtocol?
    
    private let imagePicker: UIImagePickerController
    
    public override init() {
        imagePicker = UIImagePickerController()
        super.init()
        imagePicker.delegate = self
    }
    
}

// MARK: - Main actions
public extension ImagePickerManager {
    
    /// Will show action sheet alert with available options for adding photos
    func addPhoto() async {
        let actions: [UIAlertAction] = await [
            UIAlertAction(title: "Take Photo"  , style: .default    , action: takePhoto  ),
            UIAlertAction(title: "Choose Photo", style: .default    , action: choosePhoto),
            UIAlertAction(title: "Cancel"      , style: .cancel)
        ]
        let alert = await UIAlertController(
            title: "Please choose option for add photo.",
            message: "",
            preferredStyle: .actionSheet,
            actions: actions
        )
        await self.delegate?.showAlert(alert)
    }
    
}

// MARK: - Privates
private extension ImagePickerManager {
    
    /// Open camera to take photo
    func takePhoto() async {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        if cameraAuthorizationStatus == .authorized {
            await self.imagePicker.changeSourceType(.camera)
            await self.delegate?.presentImagePicker(imagePicker)
        } else {
            await requestCameraPermission()
        }
    }
    
    /// Open image gallery
    func choosePhoto() async {
        let photoLibraryAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        if photoLibraryAuthorizationStatus == .authorized {
            await self.imagePicker.changeSourceType(.photoLibrary)
            await self.delegate?.presentImagePicker(imagePicker)
        } else {
            await requestPhotoLibraryPermission()
        }
    }
    
    /// Request permission to use camera
    func requestCameraPermission() async {
        guard await AVCaptureDevice.requestAccess(for: .video) else {
            await self.showAlertUnableAccess()
            return
        }
        
        await self.imagePicker.changeSourceType(.camera)
        await self.delegate?.presentImagePicker(self.imagePicker)
        
    }
    
    /// Request permission for read and write to photo library
    func requestPhotoLibraryPermission() async {
        if await PHPhotoLibrary.requestAuthorization(for: .readWrite) == .authorized {
            await self.imagePicker.changeSourceType(.photoLibrary)
            await self.delegate?.presentImagePicker(self.imagePicker)
        } else {
            await self.showAlertUnableAccess()
        }
    }
    
    /// Show alert access to photo lib is unavailable
    func showAlertUnableAccess() async {
        let alert = await UIAlertController(
            title: "Access to photo restricted",
            message: "Allow access to photos in app settings",
            preferredStyle: .alert
        )
        await alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        await self.delegate?.showAlert(alert)
    }
    
    
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ImagePickerManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            Task {
                guard let img = info[.originalImage] as? UIImage else { return }
                let image = img.fixOrientation()
                self.delegate?.didFinishPickingImage(image: image)
            }
        }
        
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

public extension UIImage {
    
    /// Will fix photo orientation
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: self.size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return normalizedImage
    }
}
