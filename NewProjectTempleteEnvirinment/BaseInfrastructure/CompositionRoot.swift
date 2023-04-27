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
    
    
    func resolveLoginViewController() async -> LoginViewController {
        let vc = await LoginViewController.instantiateFromStoryboard("LoginViewController")
        let viewModel = LoginViewModel(view: vc)
        await vc.set(viewModel: viewModel)
        return vc
    }
    
    func resolveRegistrationViewController() async -> RegistrationViewController {
        let vc = await RegistrationViewController.instantiateFromStoryboard("RegistrationViewController")
        let viewModel = RegistrationViewModel(view: vc)
        await vc.set(viewModel: viewModel)
        return vc
    }
    
    func resolveForgotPasswordViewController() async -> ForgotPasswordViewController {
        let vc = await ForgotPasswordViewController.instantiateFromStoryboard("ForgotPasswordViewController")
        let viewModel = ForgotPasswordViewModel(view: vc)
        await vc.set(viewModel: viewModel)
        return vc
    }
}



// MARK: Global flow
extension CompositionRoot {
    
    func resolveOTPViewController(otpCase: OPTViewCase, completion: @escaping (Bool) -> Void) async -> OTPViewController {
        let vc = await OTPViewController.instantiateFromStoryboard("OTPViewController")
        let viewModel = OTPViewModel(view: vc, otpCase: otpCase, completion: completion)
        await vc.set(viewModel: viewModel)
        return vc
    }
    
    func resolveVideoPlayerViewController(url: URL) async -> VideoPlayerViewController {
        let vc = await VideoPlayerViewController.instantiateFromStoryboard("VideoPlayerViewController")
        let viewModel = VideoPlayerViewModel(view: vc, url: url)
        await vc.set(viewModel: viewModel)
        return vc
    }
        
}


// MARK: Main flow
extension CompositionRoot {
    
    
    func resolveMainViewController() async -> MainViewController {
        let vc = await MainViewController.instantiateFromStoryboard("MainViewController")
        let viewModel = MainViewModel(view: vc)
        await vc.set(viewModel: viewModel)
        return vc
    }
    
    func resolveAudioRecodingViewController() async -> AudioRecodingViewController {
        let vc = await AudioRecodingViewController.instantiateFromStoryboard("AudioRecodingViewController")
        let viewModel = AudioRecodingViewModel(view: vc)
        await vc.set(viewModel: viewModel)
        return vc
    }
    
    func resolvePhotoViewerViewController(url: URL) async -> PhotoViewerViewController {
        let vc = await PhotoViewerViewController.instantiateFromStoryboard("PhotoViewerViewController")
        let viewModel = PhotoViewerViewModel(view: vc, url: url)
        await vc.set(viewModel: viewModel)
        return vc
    }

    func resolveVideoCapturerViewController() async -> VideoCapturerViewController {
        let vc = await VideoCapturerViewController.instantiateFromStoryboard("VideoCapturerViewController")
        let viewModel = VideoCapturerViewModel(view: vc)
        await vc.set(viewModel: viewModel)
        return vc
    }
    
    func resolveLiveStreamViewController() async -> LiveStreamViewController {
        let vc = await LiveStreamViewController.instantiateFromStoryboard("LiveStreamViewController")
        let viewModel = LiveStreamViewModel(view: vc)
        await vc.set(viewModel: viewModel)
        return vc
    }
   
    func resolveEvidenceSectionViewController() async -> EvidenceSectionViewController {
        let vc = await EvidenceSectionViewController.instantiateFromStoryboard("EvidenceSectionViewController")
        let viewModel = await MainActor.run(resultType: EvidenceSectionViewModel.self) { EvidenceSectionViewModel(view: vc) }
        await vc.set(viewModel: viewModel)
        return vc
    }
    
    func resolveMenuViewController(viewRect: CGRect, from menuItem: MenuItem,
                                   completion: @escaping () -> Void) async -> MenuViewController {
        let vc = await MenuViewController.instantiateFromStoryboard("MenuViewController")
        let viewModel = MenuViewModel(view: vc, menuItem) { completion() }
        await vc.set(viewModel: viewModel)
        await MainActor.run { vc.view.frame = viewRect }
        return vc
    }
    
}
