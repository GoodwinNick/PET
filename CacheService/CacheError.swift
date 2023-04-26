import Foundation

public enum CacheError: Error {
    case dataIsNil
    case clearCache
    case clearContents
    case badUrl
}

extension CacheError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .dataIsNil:
            return NSLocalizedString("Sended for saving data is nil.", comment: "")
        case .clearCache:
            return NSLocalizedString("Error while clearing cache.", comment: "")
        case .clearContents:
            return NSLocalizedString("Error while clearing contents.", comment: "")
        case .badUrl:
            return NSLocalizedString("Wrong URL for searching directory.", comment: "")
        }
    }

}
