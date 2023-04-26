
import Foundation
import CoreLocation

public protocol LocationUpdatedDelegate: AnyObject {
    
    /// Value of subscriber ID. Shoud be defined in delegate and shoud not be the same if you use a few members of one class
    var locationDelegateId: String { get }
    
    /// Main function for get an updates
    func locationUpdated(location: CLLocation)
}
