import UIKit

extension UICollectionView: CollectionUsableView {
    @MainActor func reloadDataOnMain() async {
        self.reloadData()
    }
}
