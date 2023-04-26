import AVFoundation
import UIKit
import AVKit

public enum AlarmError: Error, LocalizedError {
    case errorSettingCategory
    case errorSettingActive
    case errorGettingSoundUrl
    case errorConfigAudioPlayer
    case alarmAlreadyActive
}

public class AlarmManager {
    private      var flashTimer: Timer?
    private(set) var isAlarmActive = false
    private      var audioPlayer: AVAudioPlayer?
    private      let bundleID = "com.goodwinNJ.AlarmService"
    private      let soundName = "police-siren"
    public static let shared = AlarmManager()
    
    private init(flashTimer: Timer? = nil, isAlarmActive: Bool = false, audioPlayer: AVAudioPlayer? = nil) {
        self.flashTimer = flashTimer
        self.isAlarmActive = isAlarmActive
        self.audioPlayer = audioPlayer
    }
    
  
   
    
   
}


// MARK: - Main actions
public extension AlarmManager {
    
    /// Start alarm action
    func startAlarm() throws {
        let session = AVAudioSession.sharedInstance()
        do {
            guard !isAlarmActive else { throw AlarmError.alarmAlreadyActive }
            isAlarmActive = true
            
            try prepareSession(session)
            
           try preparePlayer()
            
            startFlash()
        } catch let error {
            isAlarmActive = false
            throw error
        }
        
        audioPlayer?.numberOfLoops = -1
        audioPlayer?.prepareToPlay()
        audioPlayer?.volume = 0.5
        audioPlayer?.play()
    }
    
    /// Stop alarm action
    func stopAlarm() {
        isAlarmActive = false
        flashTimer?.invalidate()
        audioPlayer?.stop()
        audioPlayer = nil
    }
}


// MARK: - Flash actions
private extension AlarmManager {
    /// Start flash action
    func startFlash() {
        flashTimer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            if self.isAlarmActive {
                self.toggleFlash()
            } else {
                timer.invalidate()
            }
        }
    }
    
    /// Toggle flash action
    func toggleFlash() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        do {
            try device.lockForConfiguration()
            if device.torchMode == .on {
                device.torchMode = .off
            } else {
                try device.setTorchModeOn(level: 1.0)
            }
            device.unlockForConfiguration()
        } catch {
            print("Ошибка включения/выключения вспышки на устройстве")
        }
    }
}



// MARK: - Heplers
private extension AlarmManager {
    
    
    /// Will prepare session for playing audio
    func prepareSession(_ session: AVAudioSession) throws {
        try throwing(possibleError: .errorSettingCategory, debugString: "Failed to set audio session category:") {
            try session.setCategory(.playAndRecord, options: [.defaultToSpeaker])
        }
        
        try throwing(possibleError: .errorSettingActive, debugString: "Failed to set audio session category:") {
            try session.setActive(true)
        }
    }
    
    /// Will prepare player for playing audio
    func preparePlayer() throws {
        guard let bundle = Bundle(identifier: bundleID),
              let alarmSound = bundle.url(forResource: soundName, withExtension: "mp3") else {
            isAlarmActive = false
            throw AlarmError.errorGettingSoundUrl
        }
        
        try throwing(possibleError: .errorConfigAudioPlayer, debugString: "Ошибка проигрывания звука тревоги") {
            audioPlayer = try AVAudioPlayer(contentsOf: alarmSound)
        }
    }
    
    
    /// throwing function for better style. Will throw specific error instead of system error in some action failed.
    private func throwing(possibleError alarmError: AlarmError, debugString: String? = nil, completion: () throws -> Void) throws {
        do {
            try completion()
        } catch {
#if DEBUG
            print("\(debugString ?? "nil debugString") \(error.localizedDescription)")
#endif
            throw alarmError
        }
    }
    
}
