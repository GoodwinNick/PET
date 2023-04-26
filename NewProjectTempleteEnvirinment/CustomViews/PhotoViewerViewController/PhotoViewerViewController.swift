import UIKit

class PhotoViewerViewController: BaseViewController<PhotoViewerViewModel> {
    @IBOutlet weak var imageScrollView: UIScrollView! {
        didSet {
            imageScrollView.delegate = self
            imageScrollView.maximumZoomScale = 5.0
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    
}


// MARK: - PhotoViewerView
extension PhotoViewerViewController: PhotoViewerView {
    func setImage(uiimage: UIImage) {
        imageView.image = uiimage
    }

}

// MARK: - UIScrollViewDelegate
extension PhotoViewerViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
