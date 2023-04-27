import UIKit
import DSWaveformImageViews

protocol AudioRecodingView: BaseViewConnector {
    func loadRecordingUI()
    func updateButton(isRecorded: Bool)
    func getWaveView() -> WaveformLiveView
    func updateTimeLabel(_ time: TimeInterval)
    
    func configWaveView() 
}
