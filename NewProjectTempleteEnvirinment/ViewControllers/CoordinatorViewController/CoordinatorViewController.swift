import UIKit

class CoordinatorViewController: BaseViewController<CoordinatorViewModel> {
    
  
}


// MARK: - UI
extension CoordinatorViewController {
    override func configUI() {
        super.configUI()
    }
    
    override func configColors() {
        super.configColors()
        self.view.backgroundColor = ColorManager.ColorCase.background.color
    }
}

// MARK: - CoordinatorView
extension CoordinatorViewController: CoordinatorView {
    
}
