import UIKit

public final class PowerModeManager: NSObject {
    
    private let collector = PowerModeDelegatesCollector()
    
    public let shared = PowerModeManager()
    
    private override init() {
        super.init()
        NotificationCenter
            .default
            .addObserver(
                self,
                selector: #selector(powerModeChanged),
                name: .NSProcessInfoPowerStateDidChange,
                object: nil
            )
    }
    
    deinit { NotificationCenter.default.removeObserver(self) }
    
}

// MARK: - Main actions
public extension PowerModeManager {
    
    /// Subscribe for updates
    func subscribe(_ subscriber: WeakPowerModeUpdationDelegate) async throws {
        try await collector.addDelegate(subscriber)
    }
    
    /// Unsubscribe for updates
    func unsubscribe(_ subscriber: WeakPowerModeUpdationDelegate) async throws {
        try await collector.removeDelegate(subscriber)
    }
}

// MARK: - Observer actions
private extension PowerModeManager {
    
    /// For get an update of LowPowerMode changed
    @objc func powerModeChanged(notification: NSNotification) {
        Task(priority: .background) {
            let isLowPowerModeEnabled = ProcessInfo.processInfo.isLowPowerModeEnabled
            await notifySubscribers(isLowPowerModeEnabled: isLowPowerModeEnabled)
        }
    }
    
}

// MARK: - Helpers
private extension PowerModeManager {
    
    /// Will notify all subscribers with update
    func notifySubscribers(isLowPowerModeEnabled: Bool) async {
        await collector.sendNewInfo(isLowPowerModeEnabled: isLowPowerModeEnabled)
    }
    
}
