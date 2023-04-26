import UIKit

extension UINib {
    convenience init(_ nibName: String) {
        self.init(nibName: nibName, bundle: nil)
    }
}

