
import Foundation

public enum ErrorBiometricalAuth: Error, LocalizedError {
    /// Not supported on this device
    case notSupportedOnDevice
    
    case notEvaluateBiometric
    case unknownError

    var localizedDescription: String {
        switch self {
        case .notSupportedOnDevice: return "Ooops!!.. This feature is not supported."
        case .notEvaluateBiometric: return "Sorry!!.. Could not evaluate policy."
        case .unknownError        : return "Something went wrong. Please try again."
        }
    }
}
