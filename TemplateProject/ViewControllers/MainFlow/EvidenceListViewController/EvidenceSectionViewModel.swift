import UIKit
import CacheService
import SVProgressHUD
import ImagePickerService

class EvidenceSectionViewModel: BaseViewModel {
    
    // MARK: - Properties and outlets
    weak var view: EvidenceSectionView?
    let dataSource = DataSource<EvidenceFileCellModel>()
    let imageManager: ImagePickerManager = ImagePickerManager()
    
    let sections: [SectionPath] = [.audioRecords, .videoRecords, .photo]
    
    @objc dynamic var selectedIndex = 0 {
        didSet {
            Task(priority: .userInitiated) { await configDataSource() }
            
        }
    }
    
    private let dateFormatter = DateFormatterManager.shared
    
    
    var cellID: String {
        "EvidenceFileTableViewCell"
    }
    
    init(view: EvidenceSectionView) {
        self.view = view
        super.init()
    }
    
  
   
}



// MARK: - Standard overriding
extension EvidenceSectionViewModel {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view?.subscribe(dataSource)
        imageManager.delegate = self
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        Task(priority: .background) {
            await configDataSource()
        }
    }
    
}

// MARK: - Actions
extension EvidenceSectionViewModel {
    func clearCache() {
        Task(priority: .background) {
            try await CacheManager.shared.clearCache()
            await configDataSource()
        }
    }
    
    func addPhoto() {
        Task(priority: .background) { await self.imageManager.addPhoto() }
    }
    
    func startStream() {
        coordinator.move(as: .push(screen: .liveStream))
    }
    
    func addAudio() {
        coordinator.move(as: .push(screen: .audioRedorder))
    }
    
    func addVideo() {
        coordinator.move(as: .push(screen: .videoCaptirer))
    }
}

// MARK: - Initials
extension EvidenceSectionViewModel {
    
    func configDataSource() async {
        do {
            view?.showHUD()
            let cacheManager = CacheManager.shared
            let getCreationDate = cacheManager.getCreationDate
            async let files = cacheManager.getFilesList(for: sections[selectedIndex])
                
            await dataSource.config(try await files, by: >)
            view?.hideHUD()
        } catch {
            await dataSource.config([], by: >)
            view?.showErrorHUD(error: error)
        }
        
    }
    
}

// MARK: - ImagePickerManagerProtocol
extension EvidenceSectionViewModel: ImagePickerManagerProtocol {
        
    func showAlert(_ alert: UIAlertController) {
        
        coordinator.move(as: .present(screen: .alert(alert)))
    }
    
    func presentImagePicker(_ imagePickerController: UIImagePickerController) {
        coordinator.move(as: .present(screen: .takePhoto(imagePickerController)))
    }
    
    func didFinishPickingImage(image: UIImage?) {
        Task(priority: .background) {
            await self.saveImage(imageData: image?.pngData())
        }
    }
    
   
    
}

// MARK: - Helpers and data processors
private extension EvidenceSectionViewModel {
    func saveImage(imageData: Data?) async {
        view?.showHUD()
        defer { view?.hideHUD() }
        
        do {
            let filename = await dateFormatter.convert(from: .fromDate(Date()), .fileFrom) ?? "Default File Name"
            let cacheManager = CacheManager.shared
            
            try await cacheManager.saveFile(data: imageData, fileName: filename, type: .photo)
            await configDataSource()
        } catch {
            print(error)
        }
        
    }
}

// MARK: - UITableViewDataSource
extension EvidenceSectionViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        guard let cell = cell as? EvidenceFileTableViewCell,
              let model = dataSource.get(by: indexPath.item) else {
            return UITableViewCell()
        }
        
        cell.setModel(model)
        return cell
    }
}


// MARK: - UITableViewDataSource
extension EvidenceSectionViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = dataSource.get(by: indexPath.item) else {
            return
        }
        if model.sectionPath == .photo {
            coordinator.move(as: .present(screen: .photoViewer(model.fileURL)))
            return
        }
        coordinator.move(as: .present(screen: .videoPlayer(model.fileURL)))
        
    }
}
