
import UIKit

extension UITableView: CollectionUsableView {
    func reloadDataOnMain() async {
        await MainActor.run {
            self.reloadData()
        }
    }
    
    func register(_ reuseID: String) {
        self.register(UINib(reuseID), forCellReuseIdentifier: reuseID)
    }
    
    func reusableCell(_ id: String, _ index: IndexPath) -> UITableViewCell {
        self.dequeueReusableCell(withIdentifier: id, for: index)
    }
}
