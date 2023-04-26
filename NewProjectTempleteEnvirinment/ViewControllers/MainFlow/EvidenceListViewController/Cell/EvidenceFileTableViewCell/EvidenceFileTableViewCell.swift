
import UIKit
import AVFoundation
import CacheService
import ImagePickerService

class EvidenceFileTableViewCell: UITableViewCell {

    // MARK: - Properties and outlets
    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    var model: EvidenceFileCellModel? {
        didSet {
            updateCell()
        }
    }
    
}


// MARK: - Model managment
extension EvidenceFileTableViewCell {
    func setModel(_ model: EvidenceFileCellModel) {
        changeAppearance()
        self.model = model
        if model.sectionPath == .photo {
            if let data = try? Data(contentsOf: model.fileURL),
                let image = UIImage(data: data) {
                photoImageView.isHidden = false
                photoImageView.image = image.fixOrientation()
                photoImageView.cornerRadius()
            } else {
                photoImageView.isHidden = true
            }
        } else {
            photoImageView.isHidden = true
        }
    }
}


// MARK: - Standard overriding
extension EvidenceFileTableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

   
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}

// MARK: - UI
extension EvidenceFileTableViewCell {
    fileprivate func updateCell() {
        guard let model else { return }
        let string = GeneralFlowStrings.CustomString.custom(model.formattedFileName)
        self.fileNameLabel.setLabelAttributedTitle(string, .medi(size: 16, .labelText))
        
    }
    
    override func changeAppearance() {
        self.setBGColor(.secondaryBackground)
        updateCell()
    }
}
