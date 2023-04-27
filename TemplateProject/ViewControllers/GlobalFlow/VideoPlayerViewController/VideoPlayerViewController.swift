
import UIKit
import AVFoundation

class VideoPlayerViewController: BaseViewController<VideoPlayerViewModel> {
    
    // MARK: - Properties and outlets
    @IBOutlet weak var playerView: UIView!
    
    var player: AVPlayer? = nil
    
}


// MARK: - Standard overriding
extension VideoPlayerViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        player = AVPlayer(url: viewModel.videoURL)
        let playerLayer = AVPlayerLayer(player: player)
        
        // add player layer to view layer
        playerLayer.frame = self.playerView.frame
        playerLayer.videoGravity = .resizeAspectFill
        self.playerView.layer.addSublayer(playerLayer)
    }
}

// MARK: - VideoPlayerView
extension VideoPlayerViewController: VideoPlayerView {
    
}
