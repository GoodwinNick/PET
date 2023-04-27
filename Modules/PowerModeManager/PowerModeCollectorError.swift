import Foundation

public enum PowerModeCollectorError: Error {
    /// Delegate value is already subscribed for updates
    case delegateAlreayExist
    
    /// Delegate value is already removed or was not added for updates
    case delegateNotExist
    
}

extension PowerModeCollectorError: LocalizedError {
    
    public var localizedDescription: String {
        switch self {
        case .delegateAlreayExist: return "Power mode delegate already exist."
        case .delegateNotExist   : return "Power mode delegate not exist or already removed."
        }
    }
}
