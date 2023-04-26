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
    }
    
   
}


// MARK: - Standard overriding
extension AudioRecodingViewModel {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configAudioUtils()
        view?.configWaveView()
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        if audioRecorder != nil {
            finishRecording(success: true)
        }
    }
    
}

// MARK: - Actions
extension AudioRecodingViewModel {
    func recordButtonAction() {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
}

// MARK: - Timer
extension AudioRecodingViewModel {
    
    func startRecordingTimer() {
        if recordingTimer != nil {
            recordingTimer?.invalidate()
            recordingTimer = nil
        }
        
        DispatchQueue.main.async {
            self.view?.getWaveView().reset()
            self.recordingTimer = Timer
                .scheduledTimer(withTimeInterval: 0.01, repeats: true, block: self.recordingUpdate(timer:))
        }
    }
    
    func recordingUpdate(timer: Timer) {
        self.audioRecorder.updateMeters()
        let power = audioRecorder.averagePower(forChannel: 0)
        let linear = 1 - pow(10, power / 20)
        DispatchQueue.main.async { [weak self] in
            guard let self, let view = self.view, let audioRecorder = self.audioRecorder else { return }
            view.updateTimeLabel(audioRecorder.currentTime)
            view.getWaveView().add(samples: [linear, linear, linear])
        }
    }
    
}


// MARK: - Audio manipulators
extension AudioRecodingViewModel {
    /// Will configurate session, ask for permission and call UI updates if allowed
    func configAudioUtils() {
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            
            recordingSession.requestRecordPermission() { [weak self] allowed in
                DispatchQueue.main.async {
                    guard let self else { return }
                    allowed ? self.view?.loadRecordingUI() : self.view?.showErrorHUD(error: AudioError.audioCatchingNotAllowed)
                }
            }
        } catch {
            self.view?.showErrorHUD(error: error)
        }
    }
    
    /// Start recording
    func startRecording() {
        Task {
            do {
                startRecordingTime = Date()
                let filename = await converFromDate(date: startRecordingTime, format: .fileFrom)
                
                try await checkFileAvailability()
                
                let audioFilename = try await cacheManager.getFileURLWith(.audioRecords, url: filename)
                
                let settings = configAudioSettings()
                
                try initAudioRecorder(filename: audioFilename, settings: settings)
                audioRecorder.record()
                startRecordingTimer()
                
                self.view?.updateButton(isRecorded: true)
            } catch {
                self.view?.showErrorHUD(error: error)
                finishRecording(success: false)
            }
        }
        
    }
    
    // Stop recording
    func finishRecording(success: Bool) {
        audioRecorder?.stop()
        self.audioRecorder = nil
        recordingTimer?.invalidate()
        recordingTimer = nil
        stopRecordingTime = Date()
        self.view?.updateButton(isRecorded: false)
        
        Task {
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
            finishRecording(success: false)
        }
    }
    
}
