import UIKit

extension UICollectionView: CollectionUsableView {
    func reloadDataOnMain() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
}
