
import Foundation

public enum NotificationManagerError: Error, LocalizedError {
    case errorAuthorization
    case notAuthorizated
    case errorWhileAddNotificationRequest
    
    var localizedDescription: String {
        switch self {
        case .errorAuthorization:
            return "Error notification authorization. Please allow app to send notifications in Settings -> Our app."
        case .notAuthorizated:
            return "Please allow app to send notifications in Settings -> Our app."
        case .errorWhileAddNotificationRequest:
            return "Error while sending notification. Please contact support."
        }
    }
}
