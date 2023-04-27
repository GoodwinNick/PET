import UIKit

public extension UIAlertAction {
    convenience init(title: String, style: Style, action: @escaping () -> Void) {
        self.init(title: title, style: style) { _ in action() }
    }
    convenience init(title: String, style: Style, action: @escaping () async -> Void) {
        self.init(title: title, style: style) { _ in Task { await action() } }
    }
}

public extension UIAlertController {
    convenience init(title: String? = nil, message: String? = nil, preferredStyle: Style, actions: [UIAlertAction]) {
        self.init(title: title, message: message, preferredStyle: preferredStyle)
        for action in actions {
            self.addAction(action)
        }
    }
}


public extension UIImagePickerController {
    @MainActor func changeSourceType(_ newType: SourceType) async {
        self.sourceType = newType
    }
}
