import UIKit
import AVFAudio
import CacheService
import DSWaveformImage
import DSWaveformImageViews


class AudioRecodingViewController: BaseViewController<AudioRecodingViewModel> {

    @IBOutlet fileprivate weak var recordButton: UIButton!
    @IBOutlet fileprivate weak var waveView: WaveformLiveView!
    @IBOutlet fileprivate weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bindWithObserver() {
        super.bindWithObserver()
    }
}


// MARK: - Actions
extension AudioRecodingViewController {
    @objc func recordTapped() {
        viewModel.recordButtonAction()
    }
}


// MARK: - UI
extension AudioRecodingViewController {
    override func configUI() {
        super.configUI()
        
    }
    
    override func configColors() {
        super.configColors()
        self.view    .setBGColor(.background         )
        self.waveView.setBGColor(.secondaryBackground)
    }
    
    override func configStrings() {
        super.configStrings()
        let string = GeneralFlowStrings.CustomString.custom(self.timeLabel.text ?? "")
        let font = String.FontStringType.medi(size: 16, .labelText)
        self.timeLabel.setLabelAttributedTitle(string, font)
    }
    
    private func waveViewConfiguration() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let stripeConfig : Waveform.Style.StripeConfig = .init(color: .red, width: 4, spacing: 6)
            let style        : Waveform.Style              = .striped(stripeConfig)
            let configuration: Waveform.Configuration      = waveView.configuration.with(style: style, verticalScalingFactor: 2)
            
            waveView.configuration = configuration
        }
    }
}

// MARK: - AudioRecodingView
extension AudioRecodingViewController: AudioRecodingView {
    
    func updateButton(isRecorded: Bool) {
        DispatchQueue.main.async {
            if isRecorded {
                self.recordButton.setBackgroundImage(UIImage(systemName: "stop.circle"), for: .normal)
                self.recordButton.setTintColor(.gray)
            } else {
                self.recordButton.setBackgroundImage(UIImage(systemName: "record.circle"), for: .normal)
                self.recordButton.setTintColor(.red)
            }
        }
    }
    func loadRecordingUI() {
        waveView.cornerRadius()
        updateButton(isRecorded: false)
        recordButton.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
        view.addSubview(recordButton)
    }
    
    func getWaveView() -> WaveformLiveView {
        return waveView
    }
    
    func updateTimeLabel(_ time: TimeInterval) {
        let string = GeneralFlowStrings.CustomString.custom(time.stringFromTimeInterval())
        let font = String.FontStringType.medi(size: 16, .labelText)
        self.timeLabel.setLabelAttributedTitle(string, font)
    }
    
    func configWaveView() {
       waveViewConfiguration()
    }
}
