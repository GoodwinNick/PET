
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // add player layer to view layer
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.playerView.frame
        playerLayer.videoGravity = .resizeAspectFill
        self.playerView.layer.addSublayer(playerLayer)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player?.play()
    }
    
    override func configUI() {
        super.configUI()
        self.view.setBGColor(.background)
        self.playerView.setBGColor(.background)
    }
}

// MARK: - VideoPlayerView
extension VideoPlayerViewController: VideoPlayerView {
    
}
