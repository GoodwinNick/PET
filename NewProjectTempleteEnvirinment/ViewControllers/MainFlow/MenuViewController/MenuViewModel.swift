import UIKit

class MenuViewModel: BaseViewModel {
    weak var view: MenuView?
    let fromMenuItem: MenuItem
    let completion: () -> Void
    
    init(view: MenuView, _ fromMenuItem: MenuItem, completion: @escaping () -> Void) {
        self.view = view
        self.fromMenuItem = fromMenuItem
        self.completion = completion
    }
}
