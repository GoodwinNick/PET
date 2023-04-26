import UIKit


typealias FontParams = (fontType: FontType, fontSize: CGFloat, fontColor: ColorManager.ColorCase)

extension String {
    
    enum FontStringType {
        
        case medi(size: CGFloat, _ color: ColorManager.ColorCase)
        
        case medi_40_white
        case medi_23_white

        case medi_16_white
        case medi_14_white
        
        case medi_16_black
        case medi_14_black
        
        case medi_14_gray
        
        case regu_12_gray
        
        
        var fontParams: FontParams {
            let fontParams: FontParams
            switch self {
            case .medi(let size, let color): fontParams = configFontParams(.medium, size, color)
                
            case .medi_40_white     : fontParams = configFontParams(.medium, 40, .white)
                
            case .medi_23_white     : fontParams = configFontParams(.medium, 23, .white)
//            case .medi_23(let color): fontParams = configFontParams(.medium, 23, color)

            case .medi_16_white     : fontParams = configFontParams(.medium, 16, .white)
            case .medi_14_white     : fontParams = configFontParams(.medium, 14, .white)
                
            case .medi_16_black     : fontParams = configFontParams(.medium, 16, .black)
            case .medi_14_black     : fontParams = configFontParams(.medium, 14, .black)
            
            case .medi_14_gray      : fontParams = configFontParams(.medium, 14, .gray)
                
            case .regu_12_gray      : fontParams = configFontParams(.regular, 12, .gray)
            
            }
            
            return fontParams
        }
        
        private var colorManager: ColorManager {
            ColorManager.shared
        }
        
        private func configFontParams(_ fontType: FontType, _ fontSize: CGFloat, _ fontColor: ColorManager.ColorCase) -> FontParams {
            FontParams(fontType: fontType, fontSize: fontSize, fontColor: fontColor)
        }
        
    }
    
    fileprivate func font(with type: FontStringType, isUnderlined: Bool) -> NSAttributedString {
        return self.fontedString(
            fontType: type.fontParams.fontType,
            fontSize: type.fontParams.fontSize,
            fontColor: type.fontParams.fontColor,
            isUnderlined: isUnderlined
        )
    }
    
    func fontedString(fontType: FontType, fontSize: CGFloat, fontColor: ColorManager.ColorCase = .black, isUnderlined: Bool) -> NSAttributedString {
        let font = UIFont.systemFont(
            ofSize: fontSize,
            weight: fontType.fontWeight
        )
        let finalString = NSMutableAttributedString(
            string: self.localize,
            attributes: [
                NSAttributedString.Key.font: font as Any,
                .foregroundColor: fontColor.color as Any,
            ]
        )
        if isUnderlined {
            let textRange = NSRange(location: 0, length: finalString.string.count)
            finalString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: textRange)
        }
        return finalString
    }

    func fontedString(fontType: FontStringType, isUnderlined: Bool = false) -> NSAttributedString {
        return self.font(with: fontType, isUnderlined: isUnderlined)
    }
   
    var localize: String {
        return NSLocalizedString(
            self,
            bundle: getLocalizationBundle(),
            comment: self
        )
    }
    func localizeReplaced(of target: String, with replacement: String) -> String {
        return self.localize.replacingOccurrences(of: target, with: replacement)
    }
}

// MARK: Get different languages bundles for localization file choose
extension String {
    
    static var localizationBundle: Bundle? = nil
    
    func getLocalizationBundle() -> Bundle {
        if let bundle = String.localizationBundle {
            return bundle
        }
        
        let appLang = LanguageManager.shared.language.identifier
        
        guard let path = Bundle.main.path(forResource: appLang, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return Bundle.main
        }
        
        String.localizationBundle = bundle
        return bundle
    }
    
}
