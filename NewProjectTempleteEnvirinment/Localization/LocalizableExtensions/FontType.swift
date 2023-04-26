
import UIKit


enum FontType {
    
    case black
    case medium
    case bold
    case semiBold
    case light
    case extraLight
    case thin
    case heavy
    case regular
    
    /// UIFont.Weight
    var fontWeight: UIFont.Weight {
        switch self {
        case .black:
            return .black
        
        case .medium:
            return .medium
            
        case .bold:
            return .bold
            
        case .semiBold:
            return .semibold
            
        case .light:
            return .light
            
        case .extraLight:
            return .ultraLight
            
        case .thin:
            return .thin
            
        case .heavy:
            return .heavy
            
        case .regular:
            return .regular
        }
    }
}
