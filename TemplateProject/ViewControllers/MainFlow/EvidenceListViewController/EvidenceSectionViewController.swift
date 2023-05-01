import UIKit

class EvidenceSectionViewController: BaseViewController<EvidenceSectionViewModel> {

    typealias LocalStrings = MainFlowStrings.EvidenceSectionVC
    
    // MARK: - Properties and Outlets
    @IBOutlet fileprivate weak var tableView        : UITableView! { didSet { configTableView() } }
    @IBOutlet fileprivate weak var segmentControll  : UISegmentedControl!
    @IBOutlet fileprivate weak var clearCacheButton : UIButton!
    @IBOutlet fileprivate weak var addEvidenceLabel : UILabel!
    @IBOutlet fileprivate weak var audioButton      : UIButton!
    @IBOutlet fileprivate weak var videoButton      : UIButton!
    @IBOutlet fileprivate weak var photoButton      : UIButton!
    @IBOutlet fileprivate weak var liveStreamButton : UIButton!
    @IBOutlet fileprivate weak var evidenceListLabel: UILabel!
    
    
}

// MARK: - Standard overriding
extension EvidenceSectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitle(strings: LocalStrings.title)
    }

}

// MARK: - UI
extension EvidenceSectionViewController {
    
    override func configUI() {
        super.configUI()
        tableView.contentInset.bottom = UIApplication.safeAreaInsets.bottom
    }
    
    override func configStrings() {
        super.configStrings()
        let segments: [LocalStrings] = [.audioSection, .videoSection, .photoSection]
        
        segmentControll  .setSegmentsAttributedTitles(segments                      , .medi(size: 16, .labelText))
        evidenceListLabel.setLabelAttributedTitle    (LocalStrings.evidenceListLabel, .medi(size: 23, .labelText))
        addEvidenceLabel .setLabelAttributedTitle    (LocalStrings.addEvidenceLabel , .medi(size: 23, .labelText))
        
        [
            clearCacheButton: LocalStrings.clearCacheButton,
            audioButton     : LocalStrings.audioButton,
            videoButton     : LocalStrings.videoButton,
            photoButton     : LocalStrings.photoButton,
            liveStreamButton: LocalStrings.liveStreamButton
        ].forEach { $0.key?.setButtonAttributedTitle($0.value, .medi(size: 16, .bgButtonText)) }
    }
    
    override func configColors() {
        super.configColors()
        self.view.setBGColor(.background)
        segmentControll .changeAppearance()
        tableView.visibleCells.forEach { $0.changeAppearance() }
        [clearCacheButton, audioButton, videoButton, photoButton, liveStreamButton]
            .forEach { $0.config(bgColor: .buttonBackground, borderColor: .buttonBorder, borderWidth: 2, cornerRadius: 8) }
    }
    
    
}



// MARK: - Observation
extension EvidenceSectionViewController {
    
    override func bindWithObserver() {
        super.bindWithObserver()
        observer.from(segmentControll, \.selectedSegmentIndex).to(viewModel, \.selectedIndex)
    }
    
}

// MARK: - Actions
extension EvidenceSectionViewController {
    
    @IBAction func audioButtonTapped     (_ sender: UIButton) { viewModel.addAudio()    }
    
    @IBAction func videoButtonTapped     (_ sender: UIButton) { viewModel.addVideo()    }
    
    @IBAction func photoButtonTapped     (_ sender: UIButton) { viewModel.addPhoto()    }
    
    @IBAction func liveStreamButtonTapped(_ sender: UIButton) { viewModel.startStream() }
    
    @IBAction func clearCacheButtonTapped(_ sender: UIButton) { viewModel.clearCache()  }
    
    @IBAction func segmentControllChanged(_ sender: UISegmentedControl) {  }
   
}

// MARK: - Fileprivates
fileprivate extension EvidenceSectionViewController {
    
    func configTableView() {
        tableView.register(viewModel.cellID)
        tableView.dataSource = viewModel
        tableView.delegate = viewModel
    }
    
}


// MARK: - EvidenceSectionView
extension EvidenceSectionViewController: EvidenceSectionView {
    
    func subscribe<T>(_ dataSource: DataSource<T>) {
        dataSource.showingView = tableView
    }
    
}


