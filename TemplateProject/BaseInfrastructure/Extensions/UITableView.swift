
import UIKit

extension UITableView: CollectionUsableView {
    @MainActor func reloadDataOnMain() async {
        self.reloadData()
    }
    
    @MainActor func register(_ reuseID: String) {
        self.register(UINib(reuseID), forCellReuseIdentifier: reuseID)
    }
    
    @MainActor func reusableCell(_ id: String, _ index: IndexPath) -> UITableViewCell {
        self.dequeueReusableCell(withIdentifier: id, for: index)
    }
}
