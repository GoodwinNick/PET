import UIKit


extension UIView {

    func applyGradient(colours: [CGColor], locations: [NSNumber]?, for angle: CGFloat) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0 }
        gradient.locations = locations
        gradient.calculatePoints(for: angle)
        self.clipsToBounds = true
        self.layer.insertSublayer(gradient, at: 0)
    }
    
}
