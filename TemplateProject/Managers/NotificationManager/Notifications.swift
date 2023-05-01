
import UIKit


enum Notifications {

    /// Need to change all strings and the direction
    case languageChanged
    case appearanceModeChanged
    case willEnterForegroundNotification
    case didEnterBackgroundNotification
    
    var rawValue: String {
        
        switch self {
        case .languageChanged                   : return "Language.Changed"
        case .appearanceModeChanged             : return "AppearanceMode.Changed"
        case .willEnterForegroundNotification   : return "willEnterForegroundNotification"
        case .didEnterBackgroundNotification    : return "didEnterBackgroundNotification"
            
        }
    }
    
    var notificationName: Notification.Name {
        switch self {
        case .languageChanged                   : break
        case .appearanceModeChanged             : break
        case .willEnterForegroundNotification   : return UIApplication.willEnterForegroundNotification
        case .didEnterBackgroundNotification    : return UIApplication.didEnterBackgroundNotification
        }
        return Notification.Name(self.rawValue)
    }
    
    var object: Any? {
        switch self {
        case .languageChanged                   : return nil
        case .appearanceModeChanged             : return nil
        case .willEnterForegroundNotification   : return nil
        case .didEnterBackgroundNotification    : return nil
        }
    }
    
    func post() {
        NotificationCenter.default.post(
            name: self.notificationName,
            object: object
        )
    }
    
}

extension NotificationCenter {
    func addOserver(
        notifName: TemplateProject.Notifications, object obj: Any? = nil,
        queue: OperationQueue? = .main          , using block: @escaping @Sendable (Notification) -> Void
    ) {
        NotificationCenter.default.addObserver(
            forName: notifName.notificationName,
            object: obj,
            queue: queue,
            using: block
        )
    }
    
    func addOserver(
        notifName: TemplateProject.Notifications, object obj: Any? = nil,
        queue: OperationQueue? = .main          , using block: @escaping @Sendable () -> Void
    ) {
        NotificationCenter.default.addObserver(
            forName: notifName.notificationName,
            object: obj,
            queue: queue,
            using: { _ in block() }
        )
    }
    
    func addObserver(
        _ observer: Any,
        selector aSelector: Selector,
        notifName: TemplateProject.Notifications,
        object anObject: Any? = nil
    ) {
        NotificationCenter.default.addObserver(
            observer,
            selector: aSelector,
            name: notifName.notificationName,
            object: anObject
        )
    }
}

