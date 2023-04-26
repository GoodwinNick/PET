import UIKit

class ImageScrollView: UIScrollView {
    
    // Image view to display the image
    let imageView = UIImageView()
    
    init(frame: CGRect, image: UIImage) {
        super.init(frame: frame)
        
        // Set scroll view properties
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        bouncesZoom = true
        delegate = self
        
        // Set image view properties
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        
        // Set initial zoom scale to 1.0
        minimumZoomScale = 1.0
        maximumZoomScale = 3.0
        zoomScale = 1.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Set scroll view properties
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        bouncesZoom = true
        delegate = self
        
        // Set image view properties
//        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        
        // Set initial zoom scale to 1.0
        minimumZoomScale = 1.0
        maximumZoomScale = 3.0
        zoomScale = 1.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Set image view frame to fit in scroll view
        if zoomScale == minimumZoomScale {
            imageView.frame = CGRect(origin: .zero, size: imageView.image?.size ?? .zero)
        } else {
            imageView.frame = CGRect(
                origin: .zero,
                size: CGSize(width: zoomScale * (imageView.image?.size.width ?? 0), height: zoomScale * (imageView.image?.size.height ?? 0))
            )
        }
        
        // Center image view in scroll view
        let offsetX = max((bounds.width - imageView.frame.width) / 2, 0)
        let offsetY = max((bounds.height - imageView.frame.height) / 2, 0)
        contentOffset = CGPoint(x: offsetX, y: offsetY)
    }
    
}

// MARK: - UIScrollViewDelegate

extension ImageScrollView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        setNeedsLayout()
        layoutIfNeeded()
    }
    
}
