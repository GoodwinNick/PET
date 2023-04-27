
import UIKit
import UserNotifications


public final class NotificationManager: NSObject {

    static public let shared = NotificationManager()

    private override init() {}
   
}


internal extension NotificationManager {
    func handleNotification(notification: UNNotification) {
        // TODO: there need to handle some notification
        print(":")
    }
}


// MARK: - Main actions
public extension NotificationManager {
    
    /// Will send critical notification.
    /// - Parameter content: For configure content use shared.configContent(title:, body:) async -> UNMutableNotificationContent
    func sendCriticalNotification(_ content: UNMutableNotificationContent) async throws {
        let center = UNUserNotificationCenter.current()
        let isGranted: Bool
        do {
            isGranted = try await center.requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            throw NotificationManagerError.errorAuthorization
        }
        
        guard isGranted else {
            throw NotificationManagerError.notAuthorizated
        }

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "criticalNotification", content: content, trigger: trigger)
        do {
            try await center.add(request)
        } catch {
            throw NotificationManagerError.errorWhileAddNotificationRequest
        }
        
    }
    
    /// Will configure content of notification
    func configContent(title: String, body: String) async -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.defaultCritical
        content.categoryIdentifier = "criticalNotification"
        return content
    }
}


// MARK: - UNUserNotificationCenterDelegate
extension NotificationManager: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        handleNotification(notification: response.notification)
        completionHandler()
    }
}

