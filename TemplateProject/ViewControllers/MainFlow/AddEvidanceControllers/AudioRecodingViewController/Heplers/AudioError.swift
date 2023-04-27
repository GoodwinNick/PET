import Foundation


public enum AudioError: Error {
    case emptyFileName
    case existingFileName
    case audioCatchingNotAllowed
}

extension AudioError: LocalizedError {
    // TODO: Move to localization file
    public var localizedDescription: String? {
        switch self {
        case .emptyFileName           : return "Please enter the file name"
        case .existingFileName        : return "File with entered name is already exist."
        case .audioCatchingNotAllowed : return "Audio recoding is not allowed. Please allow it in Settings."
        }
    }

}

