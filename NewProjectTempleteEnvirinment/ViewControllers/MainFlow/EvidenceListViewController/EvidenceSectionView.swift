import UIKit

protocol EvidenceSectionView: BaseViewConnector {
    func subscribe<T>(_ dataSource: DataSource<T>)
}
