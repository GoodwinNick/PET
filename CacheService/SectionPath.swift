
import Foundation

public indirect enum SectionPath: Equatable, CaseIterable {
    public static var allCases: [SectionPath] = [
        .videoRecords,
        .audioRecords,
        .photo,
        .txt
    ]
    
    case audioRecords
    case videoRecords
    case photo
    case txt
    /// Using .temp(.temp) will call infinite reccursion and crash app.
    case temp(SectionPath)
    
    var pathValue: String {
        switch self {
        case .audioRecords: return "AudioRecords/"
        case .videoRecords: return "VideoRecords/"
        case .photo       : return "Photos/"
        case .txt         : return "TextFiles/"
        case .temp        : return "Temp/"
        }
    }
    
    public var fileExtension: String {
        switch self {
        case .audioRecords: return ".m4a"
        case .videoRecords: return ".mp4"
        case .photo       : return ".png"
        case .txt         : return ".txt"
            
        case .temp(let section):
            if section.isTemp { fatalError("This will call infinite reccursion and crash app.") }
            return section.fileExtension
        }
    }
    
    public static func == (lhs: SectionPath, rhs: SectionPath) -> Bool {
        return lhs.pathValue == rhs.pathValue
    }
    
    private var isTemp: Bool {
        if case .temp(_) = self {
            return true
        }
        return false
    }
}

