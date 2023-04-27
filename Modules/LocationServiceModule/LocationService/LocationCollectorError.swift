

import Foundation

public enum LocationCollectorError: Error {
    
    /// Delegate value is already subscribed for updates
    case delegateAlreayExist
    
    /// Delegate value is already removed or was not added for updates
    case delegateNotExist
   
}

extension LocationCollectorError: LocalizedError {
    
    public var localizedDescription: String {
        switch self {
        case .delegateAlreayExist: return "Location delegate already exist"
        case .delegateNotExist   : return "Location delegate not exist or already removed."

        }
    }
    
}
