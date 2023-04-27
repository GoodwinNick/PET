import UIKit

class CoordinatorViewModel: BaseViewModel {
    weak var view: CoordinatorView?
    
    init(view: CoordinatorView) {
        self.view = view
        super.init()
    }
}

// MARK: - Standard overriding
extension CoordinatorViewModel {
    override func viewDidAppear() {
        super.viewDidAppear()
        coordinator.move(as: .push(screen: .login))
    }
}
