import UIKit
import AVKit
import AVFoundation

class CustomVideoPlayerController: AVPlayerViewController {
    
    init(url: URL) {
        super.init(nibName: nil, bundle: nil)
        self.player = AVPlayer(url: url)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player?.play()
    }
}
