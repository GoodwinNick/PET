
import AVFoundation
import HaishinKit

enum SessionConfigErrors: LocalizedError {
    case notFoundVideoDevice
    case cantConfigVideoInput
    case cantAddVideoInput
    
    case notFoundAudioDevice
    case cantConfigAudioInput
    case cantAddAudioInput
    
    case cantAddVideoOutput
    case cantAddAudioOutput
    
    var localizedDesctription: String {
        // TODO: SHould be moved to Localizable strings in future
        switch self {
        case .notFoundVideoDevice  : return "Can't find video device. Please try again."
        case .cantConfigVideoInput : return "Can't find video input. Please try again."
        case .cantAddVideoInput    : return "Can't add video input. Please try again."
        case .cantAddVideoOutput   : return "Can't add video output. Please try again."

            
        case .notFoundAudioDevice  : return "Unable to find audio device. Stream will be continued without audio."
        case .cantConfigAudioInput : return "Unable to configure audio input. Stream will be continued without audio."
        case .cantAddAudioInput    : return "Unable to add audio input. Stream will be continued without audio."
        case .cantAddAudioOutput   : return "Unable to add audio output. Stream will be continued without audio."
        }
    }
}
