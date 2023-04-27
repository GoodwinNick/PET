import AVFoundation
import UIKit
import CacheService

class VideoCapturerViewModel: BaseViewModel {
    weak var view: VideoCapturerView?

    private(set) var isRecording: Bool = false

    private var videoRecorder: VideoRecorder?
    
    private var startRecordingTime: Date?
    private var stopRecordingTime: Date?
    
    private let dateFormatter = DateFormatterManager.shared

    init(view: VideoCapturerView) {
        self.view = view
        super.init()
    }
    
    func initViewRecorder() {
        do {
            guard let view = view?.getPreviewView() else {
                coordinator.move(as: .pop(flow: .anyTopLevel))
                return
            }
            self.videoRecorder = try VideoRecorder(previewView: view)
        } catch {
            self.showErrorAndPop(error: error)
        }
    }
}


// MARK: - Standard overriding
extension VideoCapturerViewModel {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        initViewRecorder()
    }
    
}

// MARK: - Actions
extension VideoCapturerViewModel {
    
    func didTapViewForFocus(focusPoint: CGPoint) {
        try? videoRecorder?.setFocus(at: focusPoint)
    }
    
    func didTapToggleCamera() {
        Task {
            do {
                try await videoRecorder?.toggleCamera()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func didTapStart() {
        Task {
            do {
                if videoRecorder?.isRecording == true {
                    await videoRecorder?.stopRecording()
                } else {
                    startRecordingTime = Date()
                    let fileName = await convertFromDate(format: .fileFrom)
                    let url = try await getUrl(for: fileName)
                    try await videoRecorder?.startRecording(url)
                }
            } catch {
                print(error)
            }
            view?.updateStartCaptureButton(isRecording: videoRecorder?.isRecording ?? false)
        }
    }
    
    func didTapToggleFlash() {
        if let isFlashOn = try? videoRecorder?.toggleFlash() {
            view?.updateFlashButton(isFlashOn: isFlashOn)
        }

    }
}

// MARK: - Helpers
private extension VideoCapturerViewModel {
    func getUrl(for name: String) async throws -> URL {
        return try await CacheManager.shared
            .getFileURLWith(
                .videoRecords,
                url: name
            )
    }
    
    func convertFromDate(format: DateFormatterManager.Format) async -> String {
        return await dateFormatter.convert(from: .fromDate(startRecordingTime!), format) ?? "Default File Name"
    }
    
    func showErrorAndPop(error: Error) {
        print(error.localizedDescription)

        coordinator.move(as: .showAlert(title: "Error", message: error.localizedDescription, actionTitle: "Ok", action: {
            self.coordinator.move(as: .pop(flow: .anyTopLevel))
        }))
    }
}
