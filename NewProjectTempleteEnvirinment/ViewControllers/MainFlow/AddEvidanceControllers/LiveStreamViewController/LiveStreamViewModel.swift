import UIKit
import AVFoundation
import HaishinKit

class LiveStreamViewModel: BaseViewModel {
    weak var view: LiveStreamView?
    
    var rtmpStream    : RTMPStream? = nil
    var rtmpConnection: RTMPConnection? = nil
    var session: AVCaptureSession
    
    
    init(view: LiveStreamView) {
        self.view = view
        self.session = AVCaptureSession()
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configSession()
        configRTMP()
    }
    
}


// MARK: Session Configuration
private extension LiveStreamViewModel {
    
    func configSession() {

        if session.canSetSessionPreset(.hd1280x720) {
            session.sessionPreset = .hd1280x720
        }
        
        // Critical for live stream will pop if will fails
        do {
            try configVideoInput()
        } catch {
            self.showAlertWithPop(title: "Error", message: error.localizedDescription)
        }
        
        // Not so critical for live stream will show error and continue with video only
        do {
            try configAudioInput()
        } catch {
            self.showAlert(title: "Error", message: error.localizedDescription)
        }
        
        // Critical for live stream will pop if will fails
        do {
            try configVideoOutput()
        } catch {
            self.showAlertWithPop(title: "Error", message: error.localizedDescription)
        }
        
        // Not so critical for live stream will show error and continue with video only
        do {
            try configAudioOutput()
        } catch {
            self.showAlert(title: "Error", message: error.localizedDescription)
        }
        
        
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
        }
        
        view?.configPreviewLayer(session: session)
        
    }
   
    
}



// MARK: - RTMP Configuration
private extension LiveStreamViewModel {
    func configRTMP() {
        let rtmpConnection = RTMPConnection()
        rtmpConnection.connect("rtmp://192.168.31.168:1935/live")
        
        let rtmpStream = RTMPStream(connection: rtmpConnection)
        rtmpStream.videoSettings = [.width: 720, .height: 1280, .bitrate: 800_000]
        rtmpStream.audioSettings = [.sampleRate: 44_100]
        rtmpStream.publish("rkzfuTM-n")
        
        self.rtmpConnection = rtmpConnection
        self.rtmpStream = rtmpStream
    }
}


// MARK: - Helpers
extension LiveStreamViewModel {
    func showAlertWithPop(title: String, message: String) {
        self.coordinator.move(as: .showAlert(title: title,
                                             message: message,
                                             actionTitle: "Ok") {
            self.coordinator.move(as: .pop(flow: .anyTopLevel))
        })
    }
    
    func showAlert(title: String, message: String) {
        self.coordinator.move(as: .showAlert(title: title,
                                             message: message,
                                             actionTitle: "Ok") { })
    }
}


// MARK: Session Configuration Helpers
private extension LiveStreamViewModel {
    
    /// Will config video output and add it to session
    private func configVideoOutput() throws {
        let videOutput = AVCaptureVideoDataOutput()
        videOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        videOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample buffer delegate"))
        
        if session.canAddOutput(videOutput) {
            session.addOutput(videOutput)
        } else {
            throw SessionConfigErrors.cantAddVideoOutput
        }
    }

    /// Will config audio output and add it to session
    private func configAudioOutput() throws {
        let audioOutput = AVCaptureAudioDataOutput()
        audioOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "audio buffer delegate"))
        if session.canAddOutput(audioOutput) {
            session.addOutput(audioOutput)
        } else {
            throw SessionConfigErrors.cantAddAudioOutput
        }
    }
    
    /// Will config video input and add it to session
    private func configVideoInput() throws {
        guard let device = AVCaptureDevice.default(for: .video) else {
            throw SessionConfigErrors.notFoundVideoDevice
        }
        guard let videoInput = try? AVCaptureDeviceInput(device: device) else {
            throw SessionConfigErrors.cantConfigVideoInput
        }
        if session.canAddInput(videoInput) {
            session.addInput(videoInput)
        } else {
            throw SessionConfigErrors.cantAddVideoInput
        }
    }
    
    /// Will config audio input and add it to session
    private func configAudioInput() throws {
        guard let device = AVCaptureDevice.default(for: .audio) else {
            throw SessionConfigErrors.notFoundAudioDevice
        }
        guard let audioInput = try? AVCaptureDeviceInput(device: device) else {
            throw SessionConfigErrors.cantConfigAudioInput
        }
        if session.canAddInput(audioInput) {
            session.addInput(audioInput)
        } else {
            throw SessionConfigErrors.cantAddAudioInput
        }
    }
}



// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate
extension LiveStreamViewModel: AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        switch output {
        case _ where output is AVCaptureAudioDataOutput: rtmpStream?.appendSampleBuffer(sampleBuffer, withType: .audio)
        case _ where output is AVCaptureVideoDataOutput: rtmpStream?.appendSampleBuffer(sampleBuffer, withType: .video)
        default: break
        }
       
    }
    
}
