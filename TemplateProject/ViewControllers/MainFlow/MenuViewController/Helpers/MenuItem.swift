import UIKit

enum MenuItem: CaseIterable {
    
    static var allCases: [MenuItem] {
        [.evidence, .main, .logout]
    }
    
    case evidence
    case main
    case logout
    
    case nonMenuCase
    
    var string: LocalizableStrings {
        switch self {
        case .evidence : return MainFlowStrings.MenuVC.evidence
        case .main     : return MainFlowStrings.MenuVC.map
        case .logout   : return MainFlowStrings.MenuVC.logout
            
        case .nonMenuCase: return GeneralFlowStrings.CustomString.custom("")
        }
    }
    
    var action: () -> Void {
        switch self {
        case .evidence : return { Coordinator.shared.move(as: .pushOrPopTill(screen: .evidenceSection)) }
        case .main     : return { Coordinator.shared.move(as: .pushOrPopTill(screen: .main           )) }
        case .logout   : return { Coordinator.shared.move(as: .popTill      (screen: .coordinator    )) }
            
        case .nonMenuCase: return { }
        }
        
    }
}
