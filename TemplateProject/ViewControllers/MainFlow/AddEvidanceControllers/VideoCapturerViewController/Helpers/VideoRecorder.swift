import AVFoundation
import UIKit
import CacheService
import SVProgressHUD

class VideoRecorder: NSObject {
    
    private      var finalUrl    : URL?
    private      var cameraDevice: AVCaptureDevice
    private      var videoInput  : AVCaptureDeviceInput
    private      var session     : AVCaptureSession
    private      var movieOutput : AVCaptureMovieFileOutput
    private      var previewLayer: AVCaptureVideoPreviewLayer
    private      var tempUrls    : [URL] = []
   
    private(set) var isRecording        = false
    private      var isFrontCamera      = false
    private      var isFlashOn          = false
    private      var isSavingInProgress = false
    
    private      var lastTempIndex      : Int = 0
    private      var lastMergedVideoFile: Int = 0
    private      var videoCounter       : Int = 0
    
    
    init(previewView: UIView) throws {
        let cameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        
        guard let cameraDevice else { throw VideoRecorderError.haveNotAccessToCamera }
        
        self.cameraDevice = cameraDevice

        self.videoInput = try AVCaptureDeviceInput(device: cameraDevice)
        self.session = AVCaptureSession()
        self.movieOutput = AVCaptureMovieFileOutput()
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
        
        super.init()
        
        Task(priority: .high) {
           await previewLayerConfiguration(previewView)
        }
        
        try sessionConfiguration()
        Task(priority: .background) { [self] in
            self.session.startRunning()
        }
    }
    
   
}

// MARK: Main initers
extension VideoRecorder {
    @MainActor private func previewLayerConfiguration(_ previewView: UIView) {
        previewLayer.frame = previewView.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        previewView.layer.insertSublayer(previewLayer, at: 0)
    }
    
    private func sessionConfiguration() throws {
        
        self.session.beginConfiguration()
        if session.canSetSessionPreset(.high) {
            self.session.sessionPreset = .high
        }
        
        let audioDevice = AVCaptureDevice.default(for: .audio)
        let audioInput = try AVCaptureDeviceInput(device: audioDevice!)
        
        if self.session.canAddInput(audioInput) {
            self.session.addInput(audioInput)
        }
        
        if self.session.canAddInput(self.videoInput) {
            self.session.addInput(self.videoInput)
        }
                
        if self.session.canAddOutput(self.movieOutput) {
            self.session.addOutput(self.movieOutput)
            
            let connection = self.movieOutput.connection(with: .video)
            if connection?.isVideoStabilizationSupported == true {
                connection?.preferredVideoStabilizationMode = .auto
            }
        } else {
            throw VideoRecorderError.unableAddMovieFileOutput
        }
        
        self.session.commitConfiguration()
    }
}


// MARK: Main actions
extension VideoRecorder {
    
    /// Start recording action
    public func startRecording(_ url: URL) async throws {
        self.finalUrl = url
        self.tempUrls = []
        self.videoCounter += 1
        lastMergedVideoFile += 1
        lastTempIndex += 1
        let firstTempUrl = try await CacheManager.shared
            .getFileURLWith(
                .temp(.videoRecords),
                url: "Video_\(videoCounter)_\(lastTempIndex)"
            )
        
        self.movieOutput.startRecording(to: firstTempUrl, recordingDelegate: self)
        self.isRecording = true
        self.tempUrls.append(firstTempUrl)
    }
    
    /// Stop recording action
    public func stopRecording() async {
        if self.isRecording {
            self.isSavingInProgress = true
            self.movieOutput.stopRecording()
            self.isRecording = false
            await SVProgressHUD.showProgress(0.0)
        }
    }
   
    
    /// Toggle camera action
    public func toggleCamera() async throws {
        let newCameraPosition: AVCaptureDevice.Position = self.isFrontCamera ? .back : .front
        guard let newCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: newCameraPosition) else {
            throw VideoRecorderError.haveNotAccessToCamera
        }
        
        try reconfigSessionForToggleCamera(newCameraDevice)
       
        if isRecording {
            try await changeVideoFileAfterToggleCamera()
        }
        
    }
    
    /// Toggle flash action
    public func toggleFlash() throws -> Bool {
        guard self.cameraDevice.hasTorch else {
            throw VideoRecorderError.deviceHasNoTorch
        }
        
        do {
            try self.cameraDevice.lockForConfiguration()
            self.cameraDevice.torchMode = self.isFlashOn ? .off : .on
            self.cameraDevice.unlockForConfiguration()
            self.isFlashOn.toggle()
        } catch {
            throw VideoRecorderError.unableToToggleFlash
        }
        return self.isFlashOn
    }
    
    /// Set focus action
    public func setFocus(at point: CGPoint) throws {
        try cameraDevice.lockForConfiguration()
        changeFocus(at: point)
        cameraDevice.unlockForConfiguration()
    }
}


// MARK: - Helpers
private extension VideoRecorder {
    
    /// Will check if available to set FocusPointOfInterest and ExposurePointOfInterest and set it is it is available
    private func changeFocus(at point: CGPoint) {
        if cameraDevice.isFocusPointOfInterestSupported {
            cameraDevice.focusPointOfInterest = point
            cameraDevice.focusMode = .continuousAutoFocus
        }
        if cameraDevice.isExposurePointOfInterestSupported {
            cameraDevice.exposurePointOfInterest = point
            cameraDevice.exposureMode = .continuousAutoExposure
        }
    }
    /// Will reconfig session with new camera device
    private func reconfigSessionForToggleCamera(_ newCameraDevice: AVCaptureDevice) throws {
        self.session.stopRunning()
        self.session.beginConfiguration()
        
        let newVideoInput = try AVCaptureDeviceInput(device: newCameraDevice)
        
        self.session.removeInput(self.videoInput)
        
        if self.session.canAddInput(newVideoInput) {
            self.session.addInput(newVideoInput)
            self.videoInput = newVideoInput
            self.cameraDevice = newCameraDevice
            self.isFrontCamera = !self.isFrontCamera
        } else {
            throw VideoRecorderError.unableSwitchCamera
        }
#if DEBUG
        print(self.session.outputs)
#endif
        self.session.commitConfiguration()
        self.session.startRunning()
    }
    
    /// Will increase lastTempIndex and create new file for video
    private func changeVideoFileAfterToggleCamera() async throws {
        lastTempIndex += 1
        
        let nextTempUrl = try await CacheManager.shared
            .getFileURLWith(
                .temp(.videoRecords),
                url: "Video_\(videoCounter)_\(lastTempIndex)"
            )
        
        self.movieOutput.startRecording(to: nextTempUrl, recordingDelegate: self)
        self.tempUrls.append(nextTempUrl)
    }
    
    
    /// Saving video progress
    private func savingVideo() async {
        if self.isSavingInProgress {
            await SVProgressHUD.showProgress(0.25)

            do {
                let tempURLS: [URL] = tempUrls
                let mergedTempUrl: URL = try await CacheManager.shared
                    .getFileURLWith(
                        .temp(.videoRecords),
                        url: "MergedVideoFile\(lastMergedVideoFile)"
                    )
                await SVProgressHUD.showProgress(0.5)
                guard let finalUrl else {
                    throw VideoRecorderError.finalURLIsEmpty
                }
                _ = try await mergeVideos(urls: tempURLS, mergedTempURL: mergedTempUrl, outputURL: finalUrl)
                await SVProgressHUD.showProgress(1.0)

                await SVProgressHUD.dismiss()
            } catch {
                await SVProgressHUD.showError(withStatus: error.localizedDescription)
                
            }
        }
    }
}

// MARK: - AVCaptureFileOutputRecordingDelegate
extension VideoRecorder: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) { }
    
    func fileOutput(_ output: AVCaptureFileOutput,
                    didFinishRecordingTo outputFileURL: URL,
                    from connections: [AVCaptureConnection], error: Error?) {
        Task { await savingVideo() }
    }
}


// MARK: - Video after processors(merger of videos for connect videos from different cammers in one file | Video transformer for set correct video orientation)
fileprivate extension VideoRecorder {
    
    
    /// Will merge temporary files.
    /// - Parameters:
    ///   - urls: Array of Temp URLs
    ///   - mergedTempURL: Temporary file of merged files
    ///   - outputURL: final file url of processed videos
    /// - Returns: final file url of processed videos
    func mergeVideos(urls: [URL], mergedTempURL: URL, outputURL: URL) async throws -> URL {
        let composition = AVMutableComposition()
        var currentTime = CMTime.zero
        let videoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        let audioTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        for videoUrl in urls {
            let asset = AVAsset(url: videoUrl)
            let assetTracks = try await asset.load(.tracks)
            let assetDuration = try await asset.load(.duration)
            let timeRange = CMTimeRange(start: .zero, duration: assetDuration)

            for track in assetTracks {
                if track.mediaType == .audio, let audioTrack {
                    try audioTrack.insertTimeRange(timeRange, of: track, at: currentTime)
                } else if track.mediaType == .video, let videoTrack {
                    try videoTrack.insertTimeRange(timeRange, of: track, at: currentTime)
                }
            }
            currentTime = CMTimeAdd(currentTime, asset.duration)
            try CacheManager.shared.removeFile(with: videoUrl)
        }
        
        let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality)
        exportSession?.outputURL = mergedTempURL
        exportSession?.outputFileType = .mp4
        await SVProgressHUD.showProgress(0.75)
        await exportSession?.export()
        
        if let error = exportSession?.error {
            throw error
        }
        
        return try await self.turnVideo(inputURL: mergedTempURL, outputURL: outputURL)
        
    }
    
    /// Will turn video for fix orientation issues after merging video
    /// - Parameters:
    ///   - inputURL: Temporary file of merged files
    ///   - outputURL: final file url of processed videos
    /// - Returns: final file url of processed videos
    func turnVideo(inputURL: URL, outputURL: URL) async throws -> URL {
        await SVProgressHUD.showProgress(0.85)
        
        let asset = AVAsset(url: inputURL)
        
        let composition = AVMutableComposition()
            
        let videoCompositionTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        let audioCompositionTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        let (tracks, duration) = try await asset.load(.tracks, .duration)
        
        
        let videoSize: CGSize
        
        if let videoTrack = tracks.first(where: { $0.mediaType == .video }),
           let videoCompositionTrack {
            videoSize = try await videoTrack.load(.naturalSize)
            try videoCompositionTrack.insertTimeRange(CMTimeRange(start: .zero, duration: duration), of: videoTrack, at: .zero)
        } else {
            throw VideoRecorderError.videoTrackNotFound
        }
        
        if let audioTrack = tracks.first(where: { $0.mediaType == .audio }),
           let audioCompositionTrack {
            try audioCompositionTrack.insertTimeRange(CMTimeRange(start: .zero, duration: duration), of: audioTrack, at: .zero)
        } else {
            print("if let audioTrack is nil in turnVideo")
        }
         
        let transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
            .scaledBy(
                x: videoSize.width / videoSize.height,
                y: videoSize.height / videoSize.width
            )

        videoCompositionTrack?.preferredTransform = transform

        guard let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality) else {
            throw VideoRecorderError.failedCreateAVAssetExportSession
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mp4
        await SVProgressHUD.showProgress(0.9)
        await exportSession.export()
        await SVProgressHUD.showProgress(0.99)
        if let error = exportSession.error {
            throw error
        } else {
            try CacheManager.shared.removeFile(with: inputURL)
            return outputURL
        }
    }
}

