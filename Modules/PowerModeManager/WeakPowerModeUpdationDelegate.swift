import Foundation

public final class WeakPowerModeUpdationDelegate {
    weak var value : PowerModeChangeDelegate?
    
    public init(value: PowerModeChangeDelegate) {
        self.value = value
#if DEBUG
        print("WeakPowerModeUpdationDelegate inited")
#endif
    }
    
    deinit {
#if DEBUG
        print("WeakPowerModeUpdationDelegate deinited")
#endif
    }
    
}


// MARK: - Comparable
extension WeakPowerModeUpdationDelegate {
    static public func == (lhs: WeakPowerModeUpdationDelegate, rhs: WeakPowerModeUpdationDelegate) -> Bool {
        return lhs.value?.powerModeDelegateId == rhs.value?.powerModeDelegateId
    }
}
