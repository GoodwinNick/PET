

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel    : UILabel!
    @IBOutlet weak var surnameLabel : UILabel!
    @IBOutlet weak var emailLabel   : UILabel!
    @IBOutlet weak var genderLabel  : UILabel!
    @IBOutlet weak var idLabel      : UILabel!
    @IBOutlet weak var carModelLabel: UILabel!
    @IBOutlet weak var carVinLabel  : UILabel!
    
    @IBOutlet weak var carModelInfoLabel: UILabel!
    @IBOutlet weak var carVinInfoLabel  : UILabel!
    
    typealias LocalStrings = GeneralFlowStrings.CustomString
    
    var model: CustomTableViewCellModel? {
        didSet {
            self.updateCell()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
    func set(_ model: CustomTableViewCellModel?) {
        self.model = model
    }
    
    fileprivate func updateCell() {
        guard let model else { return }
        nameLabel    .setLabelAttributedTitle(LocalStrings.custom(model.user.firstName), .medi_16_black)
        surnameLabel .setLabelAttributedTitle(LocalStrings.custom(model.user.lastName ), .medi_16_black)
        emailLabel   .setLabelAttributedTitle(LocalStrings.custom(model.user.email    ), .medi_16_black)
        genderLabel  .setLabelAttributedTitle(LocalStrings.custom(model.user.gender   ), .medi_16_black)
        idLabel      .setLabelAttributedTitle(LocalStrings.custom("\(model.user.id)"  ), .medi_16_black)
        guard let car = model.car else {
            [carModelInfoLabel, carVinInfoLabel, carModelLabel, carVinLabel]
                .forEach { $0?.isHidden = true }
            return
        }
        carModelLabel.setLabelAttributedTitle(LocalStrings.custom(car.model), .medi_16_black)
        carVinLabel  .setLabelAttributedTitle(LocalStrings.custom(car.vin  ), .medi_16_black)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        [nameLabel, surnameLabel, emailLabel, genderLabel, idLabel, carModelLabel, carVinLabel]
            .forEach { $0?.text = "" }
        [carModelInfoLabel, carVinInfoLabel, carModelLabel, carVinLabel]
            .forEach { $0?.isHidden = false }
    }
    
}
