
import Foundation


enum VideoRecorderError: Error {
    case haveNotAccessToCamera
    case unableAddMovieFileOutput
    case unableSwitchCamera
    case deviceHasNoTorch
    case unableToToggleFlash
    case finalURLIsEmpty
    case unableAccessVideoTrack
    case videoTrackNotFound
    case failedCreateAVAssetExportSession
    
}

extension VideoRecorderError: LocalizedError {
    // TODO: Move to localization file
    var localizedDescription: String {
        switch self {
        case .haveNotAccessToCamera           : return "Unable to access front camera."
        case .unableAddMovieFileOutput        : return "Unable to add movie file output."
        case .unableSwitchCamera              : return "Unable to switch camera."
        case .deviceHasNoTorch                : return "Device has no torch."
        case .unableToToggleFlash             : return "Unable to toggle flash."
        case .finalURLIsEmpty                 : return "Final URL is empty."
        case .unableAccessVideoTrack          : return "Unable to access video track."
        case .videoTrackNotFound              : return "Video track not found."
        case .failedCreateAVAssetExportSession: return "Failed to create AVAssetExportSession"
        }
    }
}
