
import Foundation
import CoreLocation


actor LocationDelegatesCollector {
    private var delegates: [WeakLocationUpdatedDelegate] = []
    
    init() { }
  
}

// MARK: - Private helpers
private extension LocationDelegatesCollector {
    
    /// Check for empty and remove nil values
    private func checkForEmpty() async {
        delegates = delegates.compactMap { $0.value != nil ? $0 : nil }
    }
    
}

// MARK: - Internal actions
extension LocationDelegatesCollector {
    
    /// Add new delegate
    /// - Parameter newDelegate: Delegate value for subscribing on updates
    func addDelegate(_ newDelegate: WeakLocationUpdatedDelegate) async throws {
        await checkForEmpty()
        
        let contains = delegates.contains { $0 == newDelegate }
        if !contains {
            delegates.append(newDelegate)
        } else {
            throw LocationCollectorError.delegateAlreayExist
        }
    }
    
    
    /// Remove  delegate
    /// - Parameter newDelegate: Delegate value for unsubscribing on updates
    func removeDelegate(_ newDelegate: WeakLocationUpdatedDelegate) async throws {
        await checkForEmpty()
        
        let contains = delegates.contains { $0 == newDelegate }
        if !contains {
            throw LocationCollectorError.delegateNotExist
        } else {
            delegates.removeAll(where: { newDelegate == $0 })
        }
    }
    
    /// Send new info about low power mode to all subscribers
    func sendNewInfo(_ location: CLLocation?) async {
        await checkForEmpty()
        if let location {
            delegates.forEach { $0.value?.locationUpdated(location: location) }
        }
    }
}
