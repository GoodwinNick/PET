
import UIKit

protocol VideoCapturerView: BaseViewConnector {
    func getPreviewView() -> UIView
    func updateStartCaptureButton(isRecording: Bool)
    func updateFlashButton(isFlashOn: Bool)
}
