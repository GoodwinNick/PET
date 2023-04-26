
import UIKit
import AVFoundation
import CacheService

class VideoCapturerViewController: BaseViewController<VideoCapturerViewModel> {
    @IBOutlet fileprivate weak var previewView: UIView!
    @IBOutlet fileprivate weak var startCaptureButton: UIButton!
    @IBOutlet fileprivate weak var cameraButton: UIButton!
    @IBOutlet fileprivate weak var flashButton: UIButton!
    
    
}


// MARK: - Standard functions
extension VideoCapturerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        previewView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
       
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
        let point = gestureRecognizer.location(in: previewView)
        let focusScaledPointX = (point.x / previewView.frame.size.width)
        let focusScaledPointY = (point.y / previewView.frame.size.height)
        let finalPoint = CGPoint(x: focusScaledPointX, y: focusScaledPointY)
        print("Tapped at point: \(finalPoint)")
        viewModel.didTapViewForFocus(focusPoint: finalPoint)
        
    }
    
    @IBAction func didTapSwitchFlash(_ sender: UIButton) {
        viewModel.didTapToggleFlash()
    }
    
    
    @IBAction func didTapSwitchCamera(_ sender: UIButton) {
        viewModel.didTapToggleCamera()
    }
    
    @IBAction func didTapStart(_ sender: UIButton) {
        viewModel.didTapStart()
        
    }
}

// MARK: - VideoCapturerView
extension VideoCapturerViewController: VideoCapturerView {
    func updateStartCaptureButton(isRecording: Bool) {
        if isRecording {
            startCaptureButton.setBackgroundImage(UIImage(systemName: "square.fill"), for: .normal)
        } else {
            startCaptureButton.setBackgroundImage(UIImage(systemName: "circle.fill"), for: .normal)
        }
    }
    
    func updateFlashButton(isFlashOn: Bool) {
        if isFlashOn {
            flashButton.setBackgroundImage(UIImage(named: "Flash On Icon"), for: .normal)
        } else {
            flashButton.setBackgroundImage(UIImage(named: "Flash Off Icon"), for: .normal)
        }
    }

    func getPreviewView() -> UIView {
        return previewView
    }
}


// MARK: - Helpers
extension VideoCapturerViewController {
    
     
    
}
