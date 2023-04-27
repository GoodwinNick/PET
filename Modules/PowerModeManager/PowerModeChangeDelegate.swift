import Foundation

public protocol PowerModeChangeDelegate: AnyObject {
    /// Value of subscriber ID. Shoud be defined in delegate and shoud not be the same if you use a few members of one class
    var powerModeDelegateId: String { get }
    
    /// Main function for get an updates 
    func powerModeChanged(isLowPowerModeEnabled: Bool)
}
