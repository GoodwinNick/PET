
import Foundation


public protocol AEOTPTextFieldDelegate: AnyObject {
    func didUserFinishEnter(the code: String)
}
