import UIKit

enum AppearanceMode {
    case white
    case black
    
    var icon: String {
        switch self {
        case .white: return "☀️"
        case .black: return "🌑"
        }
    }
}

class AppearanceModeManager {
    static let shared = AppearanceModeManager()
    var currentMode: AppearanceMode {
        didSet {
            switch currentMode {
            case .white:    UDShared.instance.isWhiteMode = true
            case .black:    UDShared.instance.isWhiteMode = false
            }
            
            Notifications.appearanceModeChanged.post()
        }
    }
    
    fileprivate init() {
        if UDShared.instance.isWhiteMode {
            currentMode = .white
        } else {
            currentMode = .black
        }
    }
    
    func switchMode() {
        switch currentMode {
        case .white:    currentMode = .black
        case .black:    currentMode = .white
        }
    }
}
