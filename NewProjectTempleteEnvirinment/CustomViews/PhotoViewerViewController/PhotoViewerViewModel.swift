import UIKit
import ImagePickerService

class PhotoViewerViewModel: BaseViewModel {
    weak var view: PhotoViewerView?
    let photoURL: URL
    
    init(view: PhotoViewerView, url: URL) {
        self.view = view
        self.photoURL = url
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let data = try? Data(contentsOf: photoURL),
              let image = UIImage(data: data) else {
            return
        }
        view?.setImage(uiimage: image.fixOrientation())
    }
}
