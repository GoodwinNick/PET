
import Foundation

class WeakLocationUpdatedDelegate {
    weak var value : LocationUpdatedDelegate?
    
    init (value: LocationUpdatedDelegate) {
        self.value = value
#if DEBUG
        print("WeakLocationUpdatedDelegate inited")
#endif
    }
    
    deinit {
#if DEBUG
        print("WeakLocationUpdatedDelegate deinited")
#endif
    }
    
}


// MARK: - Comparable
extension WeakLocationUpdatedDelegate {
    static func == (lhs: WeakLocationUpdatedDelegate, rhs: WeakLocationUpdatedDelegate) -> Bool {
        return lhs.value?.locationDelegateId == rhs.value?.locationDelegateId
    }
}
