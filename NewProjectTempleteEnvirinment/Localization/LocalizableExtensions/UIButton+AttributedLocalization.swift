
import Foundation
import UIKit

extension UIButton {
    func setButtonAttributedTitle(_ localizableString: LocalizableStrings, _ type: String.FontStringType, isUnderlined: Bool = false) {
        self.setAttributedTitle(
            localizableString.string.fontedString(fontType: type, isUnderlined: isUnderlined),
            for: .normal
        )
        
        self.setAttributedTitle(
            localizableString.string.fontedString(
                fontType: type.fontParams.fontType,
                fontSize: type.fontParams.fontSize,
                fontColor: .lightGray,
                isUnderlined: isUnderlined
            ),
            for: .disabled
        )
    }
}

extension UIBarButtonItem {
    func setBarButtonAttributedTitle(_ localizableString: LocalizableStrings, _ type: String.FontStringType, isUnderlined: Bool = false) {
        self.title = localizableString.string.localize
        let font = UIFont.systemFont(
            ofSize: type.fontParams.fontSize,
            weight: type.fontParams.fontType.fontWeight
        )
        
        self.setTitleTextAttributes(
            [
                NSAttributedString.Key.font: font as Any,
                .foregroundColor: type.fontParams.fontColor as Any,
            ],
            for: .normal
        )
    }
}

extension UITextField {
    
    func configTextFieldAttributes(
        _ localizableString : LocalizableStrings,
        placeholderType     : String.FontStringType  = .medi(size: 14, .textFieldPlaceholder),
        textType            : String.FontStringType  = .medi(size: 16, .textFieldText),
        borderColor         : ColorManager.ColorCase = .lightGray,
        borderWidth         : CGFloat                = 1,
        cornerRadius        : CGFloat                = 8,
        isUnderlined        : Bool                   = false
    ) {
        
        self.backgroundColor = ColorManager.ColorCase.textFieldBackground.color
        self.border(borderColor, width: borderWidth)
        self.cornerRadius(radius: 8)
        
        self.setTextFieldTextFont(textType)
        self.setTextFieldAttributedPlaceholder(localizableString, placeholderType, isUnderlined: isUnderlined)
    }
    
    private func setTextFieldAttributedPlaceholder(_ localizableString: LocalizableStrings, _ type: String.FontStringType, isUnderlined: Bool = false) {
        self.attributedPlaceholder = localizableString.string.fontedString(fontType: type, isUnderlined: isUnderlined)
    }
    
    private  func setTextFieldTextFont(_ type: String.FontStringType) {
        self.font = UIFont.systemFont(ofSize: type.fontParams.fontSize, weight: type.fontParams.fontType.fontWeight)
        self.textColor = type.fontParams.fontColor.color
    }
    
    override func changeAppearance() {
        UDShared.instance.isWhiteMode ? (keyboardAppearance = .light) : (keyboardAppearance = .dark)
    }
}


extension UILabel {
    
    func setLabelAttributedTitle(_ localizableString: LocalizableStrings, _ type: String.FontStringType, isUnderlined: Bool = false) {
        self.attributedText = localizableString.string.fontedString(fontType: type, isUnderlined: isUnderlined)
    }
    
    func setLabelAttributedTitle(_ string: String, _ type: String.FontStringType, isUnderlined: Bool = false) {
        self.attributedText = string.fontedString(fontType: type, isUnderlined: isUnderlined)
    }
}

extension UISegmentedControl {
    
    func setSegmentsAttributedTitles(_ localizableString: [LocalizableStrings], _ type: String.FontStringType) {
        for i in 0 ..< self.numberOfSegments {
            self.setTitle(localizableString[i].localizedString, forSegmentAt: i)
        }
        
        let font = UIFont.systemFont(
            ofSize: type.fontParams.fontSize,
            weight: type.fontParams.fontType.fontWeight
        )

        self.setTitleTextAttributes(
            [
                .font            : font as Any,
                .foregroundColor : type.fontParams.fontColor.color as Any
            ],
            for: .normal
        )
    }
    
}
