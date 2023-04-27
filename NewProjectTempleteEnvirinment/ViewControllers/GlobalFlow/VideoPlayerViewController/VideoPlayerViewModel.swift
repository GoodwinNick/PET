
import UIKit

class VideoPlayerViewModel: BaseViewModel {
    weak var view: VideoPlayerView?
    let videoURL: URL
    
    init(view: VideoPlayerView, url: URL) {
        self.view = view
        self.videoURL = url
        super.init()
    }
    
}
