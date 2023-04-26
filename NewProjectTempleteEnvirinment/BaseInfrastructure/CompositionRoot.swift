import UIKit

class CompositionRoot {
    
    static var sharedInstance: CompositionRoot = CompositionRoot()
        
}


// MARK: Auth flow
extension CompositionRoot {
    
    func resolveCoordinatorViewController() -> CoordinatorViewController {
        let vc = CoordinatorViewController.instantiateFromStoryboard("CoordinatorViewController")
        let viewModel = CoordinatorViewModel(view: vc)
        vc.set(viewModel: viewModel)
        return vc
    }
    
    
    func resolveLoginViewController() -> LoginViewController {
        let vc = LoginViewController.instantiateFromStoryboard("LoginViewController")
        let viewModel = LoginViewModel(view: vc)
        vc.set(viewModel: viewModel)
        return vc
    }
    
    func resolveRegistrationViewController() -> RegistrationViewController {
        let vc = RegistrationViewController.instantiateFromStoryboard("RegistrationViewController")
        let viewModel = RegistrationViewModel(view: vc)
        vc.set(viewModel: viewModel)
        return vc
    }
    
    func resolveForgotPasswordViewController() -> ForgotPasswordViewController {
        let vc = ForgotPasswordViewController.instantiateFromStoryboard("ForgotPasswordViewController")
        let viewModel = ForgotPasswordViewModel(view: vc)
        vc.set(viewModel: viewModel)
        return vc
    }
}



// MARK: Global flow
extension CompositionRoot {
    
    func resolveOTPViewController(otpCase: OPTViewCase, completion: @escaping (Bool) -> Void) -> OTPViewController {
        let vc = OTPViewController.instantiateFromStoryboard("OTPViewController")
        let viewModel = OTPViewModel(view: vc, otpCase: otpCase, completion: completion)
        vc.set(viewModel: viewModel)
        return vc
    }
    
    func resolveVideoPlayerViewController(url: URL) -> VideoPlayerViewController {
        let vc = VideoPlayerViewController.instantiateFromStoryboard("VideoPlayerViewController")
        let viewModel = VideoPlayerViewModel(view: vc, url: url)
        vc.set(viewModel: viewModel)
        return vc
    }
    
//    func resolveCustomVideoPlayerViewController(videoURL: URL) -> CustomVideoPlayerViewController {
//        let vc = CustomVideoPlayerViewController(videoURL: videoURL)
//        vc.modalPresentationStyle = .automatic
//        return vc
//    }
        
}


// MARK: Main flow
extension CompositionRoot {
    
    
    func resolveMainViewController() -> MainViewController {
        let vc = MainViewController.instantiateFromStoryboard("MainViewController")
        let viewModel = MainViewModel(view: vc)
        vc.set(viewModel: viewModel)
        return vc
    }
    
    func resolveAudioRecodingViewController() -> AudioRecodingViewController {
        let vc = AudioRecodingViewController.instantiateFromStoryboard("AudioRecodingViewController")
        let viewModel = AudioRecodingViewModel(view: vc)
        vc.set(viewModel: viewModel)
        return vc
    }
    
    func resolvePhotoViewerViewController(url: URL) -> PhotoViewerViewController {
        let vc = PhotoViewerViewController.instantiateFromStoryboard("PhotoViewerViewController")
        let viewModel = PhotoViewerViewModel(view: vc, url: url)
        vc.set(viewModel: viewModel)
        return vc
    }

    func resolveVideoCapturerViewController() -> VideoCapturerViewController {
        let vc = VideoCapturerViewController.instantiateFromStoryboard("VideoCapturerViewController")
        let viewModel = VideoCapturerViewModel(view: vc)
        vc.set(viewModel: viewModel)
        return vc
    }
    
    func resolveLiveStreamViewController() -> LiveStreamViewController {
        let vc = LiveStreamViewController.instantiateFromStoryboard("LiveStreamViewController")
        let viewModel = LiveStreamViewModel(view: vc)
        vc.set(viewModel: viewModel)
        return vc
    }
   
    func resolveEvidenceSectionViewController() -> EvidenceSectionViewController {
        let vc = EvidenceSectionViewController.instantiateFromStoryboard("EvidenceSectionViewController")
        let viewModel = EvidenceSectionViewModel(view: vc)
        vc.set(viewModel: viewModel)
        return vc
    }
    
    func resolveMenuViewController(viewRect: CGRect, from menuItem: MenuItem, completion: @escaping (UIViewController) -> Void) -> MenuViewController {
        let vc = MenuViewController.instantiateFromStoryboard("MenuViewController")
        let viewModel = MenuViewModel(view: vc, menuItem) { completion(vc) }
        vc.set(viewModel: viewModel)
        vc.view.frame = viewRect
        return vc
    }
    
}
