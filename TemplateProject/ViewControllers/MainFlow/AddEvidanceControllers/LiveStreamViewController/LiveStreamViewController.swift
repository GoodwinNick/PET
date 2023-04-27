import UIKit
import HaishinKit
import AVFoundation

class LiveStreamViewController: BaseViewController<LiveStreamViewModel> {
    
    // MARK: - Properties and outlets
    var previewLayer : AVCaptureVideoPreviewLayer? = nil
    
}



// MARK: - Standard overriding
extension LiveStreamViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


// MARK: - LiveStreamView
extension LiveStreamViewController: LiveStreamView {
    func configPreviewLayer(session: AVCaptureSession) async {
        await MainActor.run {
            previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer!.frame = self.view.layer.bounds
            previewLayer!.videoGravity = .resizeAspectFill
            self.view.layer.insertSublayer(previewLayer!, at: 0)
        }

    }
}
