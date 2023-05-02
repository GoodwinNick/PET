
import UIKit

protocol VideoCapturerView: BaseViewConnector {
    @MainActor func getPreviewView() -> UIView
    @MainActor func updateStartCaptureButton(isRecording: Bool)
    @MainActor func updateFlashButton(isFlashOn: Bool)
}
