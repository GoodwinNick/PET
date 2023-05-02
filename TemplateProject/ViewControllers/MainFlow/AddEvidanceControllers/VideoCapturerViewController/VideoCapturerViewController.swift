
import UIKit
import AVFoundation
import CacheService

class VideoCapturerViewController: BaseViewController<VideoCapturerViewModel> {
    @IBOutlet fileprivate weak var previewView: UIView! { didSet { previewView.addGestureRecognizer(tapGesture) } }
    @IBOutlet fileprivate weak var startCaptureButton: UIButton!
    @IBOutlet fileprivate weak var cameraButton: UIButton!
    @IBOutlet fileprivate weak var flashButton: UIButton!
    
    lazy var tapGesture: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
    }()
    
}

// MARK: - Standard functions
extension VideoCapturerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

// MARK: - UI
extension VideoCapturerViewController {
    override func configUI() {
        super.configUI()
        self.view.layoutIfNeeded()
        self.previewView.layoutIfNeeded()
        
        startCaptureButton.setBackgroundImage(UIImage(systemName: "circle.fill"), for: .normal)
    }
    
    override func configColors() {
        self.view.setBGColor(.background)
    }
}

// MARK: - Actions
extension VideoCapturerViewController {
    @objc func viewTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        let focusPoint = calculateFocusPoint(for: gestureRecognizer)
        Task(priority: .userInitiated) {
            await viewModel.didTapViewForFocus(focusPoint: focusPoint)
        }
    }
    
    @IBAction func didTapSwitchFlash(_ sender: UIButton) {
        Task(priority: .userInitiated) {
            await viewModel.didTapToggleFlash()
        }
    }
    
    
    @IBAction func didTapSwitchCamera(_ sender: UIButton) {
        Task(priority: .userInitiated) {
            await viewModel.didTapToggleCamera()
        }
    }
    
    @IBAction func didTapStart(_ sender: UIButton) {
        Task(priority: .userInitiated) {
            await viewModel.didTapStart()
        }
    }
}

// MARK: - VideoCapturerView
extension VideoCapturerViewController: VideoCapturerView {
    @MainActor func updateStartCaptureButton(isRecording: Bool) {
        let imageName: String = isRecording ? "square.fill" : "circle.fill"
        startCaptureButton.setBackgroundImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @MainActor func updateFlashButton(isFlashOn: Bool) {
        let imageName: String = isFlashOn ? "Flash On Icon" : "Flash Off Icon"
        flashButton.setBackgroundImage(UIImage(named: imageName), for: .normal)
    }

    @MainActor func getPreviewView() -> UIView {
        return previewView
    }
}


// MARK: - Helpers
extension VideoCapturerViewController {
    
    private func calculateFocusPoint(for gestureRecognizer: UIGestureRecognizer) -> CGPoint {
        let point = gestureRecognizer.location(in: previewView)
        return CGPoint(
            x: point.x / previewView.frame.size.width,
            y: point.y / previewView.frame.size.height
        )
    }
     
    
}
