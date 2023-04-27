import Foundation

public enum APIError: Error {
    case decodingError
    case wrongURL
    case wrongData
    case dataIsNil
    case unknown
    case notExpectedCallback
    case notExpectedType
    case customError(message: String)
    
    public var description: String {
        switch self {
        case .decodingError           : return "decodingError"
        case .wrongURL                : return "wrongURL"
        case .wrongData               : return "wrongData"
        case .dataIsNil               : return "dataIsNil"
        case .unknown                 : return "unknown"
        case .notExpectedCallback     : return "notExpectedCallback"
        case .notExpectedType         : return "notExpectedType"
        case .customError(let message): return "\(message)"
        }
    }
}
