import Foundation

class MainFlowStrings {
    static let stringsKey = "MainFlowStrings."

    // MARK: MenuVC
    enum MenuVC: String, LocalizableStrings {
        case evidence
        case map
        case logout
        
        var string: String { MainFlowStrings.stringsKey + "EvidenceSectionVCStrings." + self.rawValue }
    }
    
    // MARK: EvidenceSectionVCStrings
    enum EvidenceSectionVC: String, LocalizableStrings {
        
        case title
        case clearCacheButton
        case addEvidenceLabel
        case audioButton
        case videoButton
        case photoButton
        case liveStreamButton
        case evidenceListLabel
        case audioSection
        case videoSection
        case photoSection
        
        var string: String { MainFlowStrings.stringsKey + "EvidenceSectionVCStrings." + self.rawValue }
    }
}

