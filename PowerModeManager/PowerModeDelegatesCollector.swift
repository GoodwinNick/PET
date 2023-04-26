import Foundation

actor PowerModeDelegatesCollector {
    private var delegates: [WeakPowerModeUpdationDelegate] = []
    
    init() { }
    
}


// MARK: - Private helpers
private extension PowerModeDelegatesCollector {
    
    /// Check for empty and remove nil values
    private func checkForEmpty() async {
        delegates = delegates.compactMap { $0.value != nil ? $0 : nil }
    }
    
}

// MARK: - Internal actions
extension PowerModeDelegatesCollector {
    
    /// Add new delegate
    /// - Parameter newDelegate: Delegate value for subscribing on updates
    func addDelegate(_ newDelegate: WeakPowerModeUpdationDelegate) async throws {
        await checkForEmpty()
        
        let contains = delegates.contains { $0 == newDelegate }
        if !contains {
            delegates.append(newDelegate)
        } else {
            throw PowerModeCollectorError.delegateAlreayExist
        }
    }

    /// Remove  delegate
    /// - Parameter newDelegate: Delegate value for unsubscribing on updates
    func removeDelegate(_ newDelegate: WeakPowerModeUpdationDelegate) async throws {
        await checkForEmpty()
        
        let contains = delegates.contains { $0 == newDelegate }
        if !contains {
            throw PowerModeCollectorError.delegateNotExist
        } else {
            delegates.removeAll(where: { newDelegate == $0 })
        }
    }
    
    
    /// Send new info about low power mode to all subscribers
    func sendNewInfo(isLowPowerModeEnabled: Bool) async {
        delegates.forEach { $0.value?.powerModeChanged(isLowPowerModeEnabled: isLowPowerModeEnabled) }
    }
}

