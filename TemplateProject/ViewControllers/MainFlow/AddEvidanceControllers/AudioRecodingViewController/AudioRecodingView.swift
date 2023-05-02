import UIKit
import DSWaveformImageViews

protocol AudioRecodingView: BaseViewConnector {
    @MainActor func loadRecordingUI()
    @MainActor func updateButton(isRecorded: Bool)
    @MainActor func getWaveView() -> WaveformLiveView
    @MainActor func updateTimeLabel(_ time: TimeInterval)
    
    @MainActor func configWaveView() 
}
