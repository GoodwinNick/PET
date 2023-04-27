import UIKit

class ColorManager {
    static let shared = ColorManager()
    
    private init() { }
    
    func getColor(_ colorCase: ColorManager.ColorCase) -> UIColor {
        return colorCase.color
    }
        
    enum ColorCase {
        // Standard
        case white
        case black
        case gray
        case lightGray
        case red
        
        // Global
        case background
        case secondaryBackground
        case shadow
        case spacer
        
        // Menu
        case transparentMenuView(alpha: CGFloat)
        case menuIdNoText

        // Label
        case labelText
        
        // Buttons
        case buttonBackground
        case noBGButtonText
        case buttonBorder
        case bgButtonText
        
        // TextFields
        case textFieldBorder
        case textFieldText
        case textFieldPlaceholder
        case textFieldBackground
        case AEOTPTextFieldBackground
        
        // ImageViews
        case biometricalPincodeImageView
        
        // Navigation
        case navigationBackgroung
        case navigationTitle
        case navigationBackButton
        
        
        
        
        var color: UIColor {
            let isWhiteMode = UDShared.instance.isWhiteMode
            let color: UIColor
            switch self {
                // Standard
            case .white     : color = .white
            case .black     : color = .black
            case .gray      : color = .gray
            case .lightGray : color = .lightGray
            case .red       : color = .red
                
                // Global
            case .background          : isWhiteMode ? (color = .white) : (color = .black)
            case .secondaryBackground : isWhiteMode ? (color = .init(hex: "c6c6c8")) : (color = .init(hex: "303032"))
            case .shadow              : isWhiteMode ? (color = .black) : (color = .white)
            case .spacer              : isWhiteMode ? (color = .black) : (color = .white)
                
                // Menu
            case .transparentMenuView(let alpha) : isWhiteMode ? (color = .black.withAlphaComponent(alpha)) : (color = .white.withAlphaComponent(alpha))
            case .menuIdNoText                   : isWhiteMode ? (color = .lightGray) : (color = .lightGray)

                // Label
            case .labelText    : isWhiteMode ? (color = .black) : (color = .white)
                
                // Buttons
            case .buttonBackground : isWhiteMode ? (color = .systemMint) : (color = .systemMint)
            case .noBGButtonText   : isWhiteMode ? (color = .black     ) : (color = .white     )
            case .buttonBorder     : isWhiteMode ? (color = .black     ) : (color = .white     )
            case .bgButtonText     : isWhiteMode ? (color = .white     ) : (color = .black     )
                
                // TextFields
            case .textFieldBorder          : isWhiteMode ? (color = .black    ) : (color = .white    )
            case .textFieldText            : isWhiteMode ? (color = .black    ) : (color = .white    )
            case .textFieldPlaceholder     : isWhiteMode ? (color = .lightGray) : (color = .lightGray)
            case .textFieldBackground      : isWhiteMode ? (color = .white    ) : (color = .black    )
            case .AEOTPTextFieldBackground : isWhiteMode ? (color = .gray     ) : (color = .gray     )
                
                // ImageViews
            case .biometricalPincodeImageView : isWhiteMode ? (color = .black) : (color = .white)
                
                // Navigation
            case .navigationBackgroung : isWhiteMode ? (color = .white) : (color = .black)
            case .navigationTitle      : isWhiteMode ? (color = .black) : (color = .white)
            case .navigationBackButton : isWhiteMode ? (color = .black) : (color = .white)

                
            }
            
            return color
        }
    }
    
}


extension UIAlertController {
    public func withUpdatedAppearance() async -> UIAlertController {
        return await MainActor.run(resultType: UIAlertController.self) {
            self.overrideUserInterfaceStyle = UDShared.instance.isWhiteMode ? .light : .dark
            return self
        }
    }
}

extension UIView {
    @objc func changeAppearance() {
        if UDShared.instance.isWhiteMode {
            overrideUserInterfaceStyle = .light
        } else {
            overrideUserInterfaceStyle = .dark
        }
        self.setBGColor(.secondaryBackground)
    }

}
extension UIDatePicker {
    func changePickerAppearance() {
        if UDShared.instance.isWhiteMode {
            overrideUserInterfaceStyle = .light
        } else {
            overrideUserInterfaceStyle = .dark
        }
        self.setBGColor(.secondaryBackground)
    }
    
}

extension UIPickerView {
    func changePickerAppearance() {
        if UDShared.instance.isWhiteMode {
            overrideUserInterfaceStyle = .light
        } else {
            overrideUserInterfaceStyle = .dark
        }
        self.setBGColor(.secondaryBackground)
    }
}

extension UISegmentedControl {
    override func changeAppearance() {
        if UDShared.instance.isWhiteMode {
            overrideUserInterfaceStyle = .light
        } else {
            overrideUserInterfaceStyle = .dark
        }
    }
}

extension UITableViewCell {
    override func changeAppearance() {
        
    }
}

extension UIView {
    func setBGColor(_ colorCase: ColorManager.ColorCase) {
        self.backgroundColor = colorCase.color
    }
    
    func setTintColor(_ colorCase: ColorManager.ColorCase) {
        self.tintColor = colorCase.color
    }
    
    @objc func changeAppearance(shadow: Bool = false, circleCornerRadius: Bool = false, border: Bool = false) {
        self.setBGColor(.background)
        if circleCornerRadius {
            self.circleCornerRadius()
        }
        if shadow {
            self.shadow(colorCase: .shadow)
        }
    }
    
    
}

extension CustomNavigationController {
    func addBottomBorder() {
        for layer in (self.navigationBar.layer.sublayers ?? []) where layer.name == "999" {
            layer.removeFromSuperlayer()
        }
        let thickness: CGFloat = 1.0
        let bottomBorder = CALayer()
        bottomBorder.name = "999"
        bottomBorder.frame = CGRect(
            x: 0,
            y: self.navigationBar.frame.size.height - thickness,
            width: self.navigationBar.frame.size.width,
            height: thickness
        )
        bottomBorder.backgroundColor = ColorManager.ColorCase.spacer.color.cgColor
        
        self.navigationBar.layer.addSublayer(bottomBorder)
    }

}

extension UIButton {
    func setTitleColor(_ colorCase: ColorManager.ColorCase) {
        self.setTitleColor(colorCase.color, for: .normal)
        self.setTitleColor(colorCase.color, for: .disabled)
    }
    
    /// Will change BG Shadow and title color
    override func changeAppearance(shadow: Bool = false, circleCornerRadius: Bool = false, border: Bool = false) {
        self.setBGColor(.buttonBackground)
        self.setTitleColor(.bgButtonText)
        if border {
            self.border(color: ColorManager.ColorCase.buttonBorder.color, width: 1)
        }
        if circleCornerRadius {
            self.circleCornerRadius()
        }
        if shadow {
            self.shadow(opacity: 0.5, offset: .init(width: 0, height: 0), radius: 6, colorCase: .shadow)
        }
    }
}

extension UILabel {
    func setTitleColor(_ colorCase: ColorManager.ColorCase) {
        self.textColor = colorCase.color
    }
    
    /// Will change text color
    override func changeAppearance(shadow: Bool = false, circleCornerRadius: Bool = false, border: Bool = false) {
        self.setTitleColor(.labelText)
    }
}

extension UITextField {
    /// Will change BG color, text color, border color
    override func changeAppearance(shadow: Bool = false, circleCornerRadius: Bool = false, border: Bool = false) {
        self.border(color: ColorManager.ColorCase.textFieldBorder.color, width: 1)
        self.cornerRadius(radius: self.frame.height / 4)
        self.textColor = ColorManager.ColorCase.textFieldText.color
        self.setBGColor(ColorManager.ColorCase.textFieldBackground)
        self.attributedPlaceholder = self.placeholder?.fontedString(fontType: .regular,
                                                                    fontSize: 15,
                                                                    fontColor: ColorManager.ColorCase.textFieldPlaceholder,
                                                                    isUnderlined: false)
    }
}



extension UIImageView {
    /// Will change titn color
    override func changeAppearance(shadow: Bool = false, circleCornerRadius: Bool = false, border: Bool = false) {
        self.tintColor = ColorManager.ColorCase.biometricalPincodeImageView.color
        if circleCornerRadius {
            self.circleCornerRadius()
        }
        if shadow {
            self.shadow(colorCase: .shadow)
        }
    }
}
