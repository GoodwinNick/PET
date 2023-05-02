import UIKit
import SVProgressHUD
import CacheService
import AVFoundation
import DSWaveformImage
import DSWaveformImageViews

class AudioRecodingViewModel: BaseViewModel {
    weak var view: AudioRecodingView?
    @objc dynamic var filename: String = ""
    
    var startRecordingTime: Date?
    var stopRecordingTime: Date?
    
    private var currentRecodringTime: TimeInterval = 0.0
    private let dateFormatter = DateFormatterManager.shared
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    
    private var cacheManager: CacheManager { CacheManager.shared }
    private let imageDrawer: WaveformImageDrawer! = WaveformImageDrawer()
    var recordingTimer: Timer?
    
    
    
    init(view: AudioRecodingView) {
        self.view = view
        super.init()
    }
    
   
}


// MARK: - Standard overriding
extension AudioRecodingViewModel {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
           await configAudioUtils()
        }
        view?.configWaveView()
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        if audioRecorder != nil {
            Task(priority: .userInitiated) {
                await finishRecording(success: true)
            }
        }
    }
    
}

// MARK: - Actions
extension AudioRecodingViewModel {
    func recordButtonAction() {
        Task(priority: .userInitiated) {
            if audioRecorder == nil {
                await startRecording()
            } else {
                await finishRecording(success: true)
            }
        }
    }
}

// MARK: - Timer
extension AudioRecodingViewModel {
    
    func startRecordingTimer() async {
        if recordingTimer != nil {
            recordingTimer?.invalidate()
            recordingTimer = nil
        }
        
        Task {
            await resetWave()
        }
        
        DispatchQueue.main.async {
            self.recordingTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
                Task { await self.recordingUpdate() }
            }
        }
        
    }
    
    func resetWave() async {
        await MainActor.run {
            self.view?.getWaveView().reset()
        }
    }
    
    func recordingUpdate() async {
        self.audioRecorder.updateMeters()
        let power = audioRecorder.averagePower(forChannel: 0)
        let linear = 1 - pow(10, power / 20)
        
        guard let view = self.view, let audioRecorder = self.audioRecorder else { return }
        await MainActor.run {
            view.updateTimeLabel(audioRecorder.currentTime)
            view.getWaveView().add(samples: [linear, linear, linear])
        }
    }
    
}


// MARK: - Audio manipulators
extension AudioRecodingViewModel {
    /// Will configurate session, ask for permission and call UI updates if allowed
    func configAudioUtils() async {
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            
            let isAllowed = await withCheckedContinuation { continuation in
                self.recordingSession.requestRecordPermission() { continuation.resume(returning: $0) }
            }

            if isAllowed {
                await self.view?.loadRecordingUI()
            } else {
                await self.view?.showErrorHUD(error: AudioError.audioCatchingNotAllowed)
            }
            
        } catch {
            await self.view?.showErrorHUD(error: error)
        }
    }
    
    /// Start recording
    func startRecording() async {
        
        do {
            startRecordingTime = Date()
            let filename = await converFromDate(date: startRecordingTime, format: .fileFrom)
            
            try await checkFileAvailability()
            
            let audioFilename = try await cacheManager.getFileURLWith(.audioRecords, url: filename)
            
            let settings = configAudioSettings()
            
            try initAudioRecorder(filename: audioFilename, settings: settings)
            audioRecorder.record()
            await startRecordingTimer()
            
            await self.view?.updateButton(isRecorded: true)
        } catch {
            await self.view?.showErrorHUD(error: error)
            await finishRecording(success: false)
        }
        
        
    }
    
    // Stop recording
    func finishRecording(success: Bool) async {
        recordingTimer?.invalidate()
        recordingTimer = nil
        audioRecorder?.stop()
        self.audioRecorder = nil
        stopRecordingTime = Date()
        await self.view?.updateButton(isRecorded: false)
        
        Task(priority: .background) {
            let originName   = await converFromDate(date: startRecordingTime, format: .fileFrom)
            let toDateString = await converFromDate(date: stopRecordingTime , format: .fileTo  )
            let newName      = originName + " -> " + toDateString
            try await renameFile(from: originName, to: newName)
        }
        
        
    }
}

// MARK: - Helpers
private extension AudioRecodingViewModel {
    
    func converFromDate(date: Date?, format: DateFormatterManager.Format) async -> String {
        guard let date else { return "Default File Name" }
        return await dateFormatter.convert(from: .fromDate(date), format) ?? "Default File Name"
    }
    
    func renameFile(from nameBefore: String, to nameAfter: String) async throws {
        try await cacheManager
            .renameFile(
                .audioRecords,
                origin: nameBefore,
                new: nameAfter
            )
    }
    
    func configAudioSettings() -> [String: Any] {
        [
            AVFormatIDKey           : Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey         : 44100.0,
            AVNumberOfChannelsKey   : 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
    }
    
    func initAudioRecorder(filename: URL, settings: [String: Any]) throws {
        audioRecorder = try AVAudioRecorder(url: filename, settings: settings)
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
    }
    
    func checkFileAvailability() async throws {
        let isAvailable = try await cacheManager.isFileNameIsAvailable(filename, fileType: .audioRecords)
        if !isAvailable {
            throw AudioError.existingFileName
        }
    }
}

// MARK: - AVAudioRecorderDelegate
extension AudioRecodingViewModel: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            Task {
               await finishRecording(success: false)
            }
        }
    }
    
}
