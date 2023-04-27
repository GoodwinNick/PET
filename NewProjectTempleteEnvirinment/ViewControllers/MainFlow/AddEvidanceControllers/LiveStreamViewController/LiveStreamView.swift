
import AVFoundation

protocol LiveStreamView: BaseViewConnector {
    func configPreviewLayer(session: AVCaptureSession) async
}
