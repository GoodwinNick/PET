import UIKit

extension UIView {
    
    func config(bgColor: ColorManager.ColorCase, borderColor: ColorManager.ColorCase, borderWidth: CGFloat, cornerRadius: CGFloat) {
        self.cornerRadius(radius: cornerRadius)
        self.border(borderColor, width: borderWidth)
        self.setBGColor(bgColor)
    }
    
    func border(color: UIColor = .black,
                width: CGFloat = 1.0) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }

    func border(_ colorCase: ColorManager.ColorCase,
                width: CGFloat = 1.0) {
        self.layer.borderColor = colorCase.color.cgColor
        self.layer.borderWidth = width
    }
    
    func cornerRadius(radius: CGFloat = 20.0) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
    }

    func circleCornerRadius() {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.height/2
    }

    func shadow(opacity: Float = 0.3,
                offset: CGSize = CGSize(width: 0, height: 1),
                radius: CGFloat = 3,
                colorCase: ColorManager.ColorCase = .shadow) {
        self.layer.shadowPath = nil
        
        self.clipsToBounds = false
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shadowColor = colorCase.color.cgColor
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds,
                                             cornerRadius: self.layer.cornerRadius).cgPath
    }
    
    func shadow(opacity: Float = 0.3,
                offset: CGSize = CGSize(width: 0, height: 1),
                radius: CGFloat = 3,
                color: UIColor = .gray) {
        self.layer.shadowPath = nil
        
        self.clipsToBounds = false
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shadowColor = color.cgColor
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds,
                                             cornerRadius: self.layer.cornerRadius).cgPath
    }

    func gradient(first: UIColor, second: UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [first.cgColor, second.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.drawsAsynchronously = true
        self.layer.addSublayer(gradient)
    }
    
    func hideAnimated(with duration: TimeInterval) {
        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve) {
            self.alpha = 0
        } completion: { _ in
            self.isHidden = true
        }
    }
    
    func showAnimated(with duration: TimeInterval) {
        self.isHidden = false
        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve) {
            self.alpha = 1
        }
    }
    
    func hideOnlyAlphaAnimated(with duration: TimeInterval) {
        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve) {
            self.alpha = 0.001
        }
    }
    
    func showOnlyAlphaAnimated(with duration: TimeInterval) {
        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve) {
            self.alpha = 1
        }
    }
}
