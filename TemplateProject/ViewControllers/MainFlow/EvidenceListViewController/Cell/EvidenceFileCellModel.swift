
import Foundation
import CacheService

struct EvidenceFileCellModel {
    let fileURL: URL
    
    var sectionPath: SectionPath? {
        let filename = fileURL.lastPathComponent
        for type in SectionPath.allCases {
            if filename.contains(type.fileExtension) == true { return type }
        }
        return nil

    }
    var fileName: String {
        var filename = fileURL.lastPathComponent
        for type in SectionPath.allCases {
            filename = filename.replacingOccurrences(of: type.fileExtension, with: "")
        }
        return filename
    }
    
    var formattedFileName: String {
        return self.fileName.replacingOccurrences(of: " -> ", with: "\n  ")
    }
    
    var creationDate: Date {
        return CacheManager.shared.getCreationDate(for: fileURL)
    }
    
  
}


// MARK: - Comparable
extension EvidenceFileCellModel {
    static func > (lhs: EvidenceFileCellModel, rhs: EvidenceFileCellModel) -> Bool {
        return lhs.creationDate > rhs.creationDate
    }
    
    static func < (lhs: EvidenceFileCellModel, rhs: EvidenceFileCellModel) -> Bool {
        return lhs.creationDate < rhs.creationDate
    }
}
