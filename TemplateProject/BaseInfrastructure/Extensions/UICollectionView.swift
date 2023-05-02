import UIKit

extension UICollectionView: CollectionUsableView {
    func reloadDataOnMain() async {
        await MainActor.run {
            self.reloadData()
        }
    }
}
