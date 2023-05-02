import UIKit
import DSWaveformImageViews

protocol AudioRecodingView: BaseViewConnector {
    @MainActor func loadRecordingUI()
    @MainActor func updateButton(isRecorded: Bool)
    func getWaveView() -> WaveformLiveView
    func updateTimeLabel(_ time: TimeInterval)
    
    func configWaveView() 
}
