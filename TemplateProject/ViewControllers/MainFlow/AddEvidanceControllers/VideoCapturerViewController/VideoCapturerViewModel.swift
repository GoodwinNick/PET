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
   
}


// MARK: - Standard overriding
extension VideoCapturerViewModel {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        Task(priority: .high) {
            await initViewRecorder()
        }
    }
    
}

// MARK: - Actions
extension VideoCapturerViewModel {
    
    func didTapViewForFocus(focusPoint: CGPoint) async {
        try? videoRecorder?.setFocus(at: focusPoint)
    }
    
    func didTapToggleCamera() async {
        do {
            try await videoRecorder?.toggleCamera()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func didTapStart() async {
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
        await view?.updateStartCaptureButton(isRecording: videoRecorder?.isRecording ?? false)
    }
    
    func didTapToggleFlash() async {
        if let isFlashOn = try? videoRecorder?.toggleFlash() {
            await view?.updateFlashButton(isFlashOn: isFlashOn)
        }

    }
}

// MARK: - Helpers
private extension VideoCapturerViewModel {
    
    func initViewRecorder() async {
        do {
            guard let view = await view?.getPreviewView() else {
                coordinator.move(as: .pop(flow: .anyTopLevel))
                return
            }
            self.videoRecorder = try VideoRecorder(previewView: view)
        } catch {
            self.showErrorAndPop(error: error)
        }
    }
    
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
