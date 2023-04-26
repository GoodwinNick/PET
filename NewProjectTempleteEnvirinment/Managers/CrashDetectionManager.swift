
import Foundation
import SafetyKit

@available(iOS 16.0, *)
class CrashDetectionManager: NSObject {
    let manager: SACrashDetectionManager = SACrashDetectionManager()
    
    override init() {
        super.init()
        manager.delegate = self
    }
}

@available(iOS 16.0, *)
extension CrashDetectionManager: SACrashDetectionDelegate {
    func crashDetectionManager(_ crashDetectionManager: SACrashDetectionManager, didDetect event: SACrashDetectionEvent) {
        print(event)
    }
}
