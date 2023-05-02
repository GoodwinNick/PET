
import UIKit
import AVFoundation
import AVKit


enum Screens {
    
    // Auth flow
    case coordinator
    case login
    case registration
    case forgotPassword
    
    // Any top level flow
    case alert      (_ vc     : UIAlertController                      )
    case takePhoto  (_ vc     : UIImagePickerController                )
    case videoPlayer(_ url    : URL                                    )
    case photoViewer(_ url    : URL                                    )
    case otp        (_ otpCase: OPTViewCase, completion: (Bool) -> Void)
    
    
    // Main flow
    case main
    case audioRedorder
    case videoCaptirer
    case liveStream
    case evidenceSection
    
}



// MARK: - Controllers getter
extension Screens {
    
    var viewController: UIViewController {
       get async {
            let CR = CompositionRoot.sharedInstance
            switch self {
                
                // MARK: Auth flow screens
            case .coordinator   : return await MainActor.run { return CR.resolveCoordinatorViewController() }
            case .login         : return await CR.resolveLoginViewController()
            case .registration  : return await CR.resolveRegistrationViewController()
            case .forgotPassword: return await CR.resolveForgotPasswordViewController()
                
                
                // MARK: Any top level screens
            case .alert      (let vc )            : return await vc.withUpdatedAppearance()
            case .takePhoto  (let vc )            : return vc
            case .videoPlayer(let url)            : return await CR.resolveCustomVideoPlayerController(url: url)
            case .photoViewer(let url)            : return await CR.resolvePhotoViewerViewController(url: url)
            case .otp(let otpCase, let completion): return await CR.resolveOTPViewController(otpCase: otpCase, completion: completion)
                
                
                // MARK: Main flow screens
            case .main                : return await CR.resolveMainViewController()
            case .audioRedorder       : return await CR.resolveAudioRecodingViewController()
            case .videoCaptirer       : return await CR.resolveVideoCapturerViewController()
            case .liveStream          : return await CR.resolveLiveStreamViewController()
            case .evidenceSection     : return await CR.resolveEvidenceSectionViewController()
                
            }
        }
    }
}


// MARK: Flow destionations of controllers
extension Screens {
    
    var flowDestination: FlowDestination {
        switch self {
        case .coordinator    : return .authFlow
        case .login          : return .authFlow
        case .registration   : return .authFlow
        case .forgotPassword : return .authFlow
            
        case .alert          : return .anyTopLevel
        case .takePhoto      : return .anyTopLevel
        case .videoPlayer    : return .anyTopLevel
        case .photoViewer    : return .anyTopLevel
        case .otp            : return .anyTopLevel
            
        case .main           : return .mainFlow
        case .audioRedorder  : return .mainFlow
        case .videoCaptirer  : return .mainFlow
        case .liveStream     : return .mainFlow
        case .evidenceSection: return .mainFlow
        }
    }
    
}


// MARK: - Flow destinations model
extension Screens {
    enum FlowDestination {
        /// Top level in navControllers in Coordinator
        case anyTopLevel
        
        case authFlow
        case mainFlow
    }
}
