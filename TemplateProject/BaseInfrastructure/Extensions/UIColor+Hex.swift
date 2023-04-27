
import UIKit


public extension UIColor {

    convenience init(hex: String, alpha: CGFloat = 1.0) {
        
        let v = Int("00000000" + hex, radix: 16) ?? 0
        let r = CGFloat(v / Int(powf(256, 2)) % 256) / 255
        let g = CGFloat(v / Int(powf(256, 1)) % 256) / 255
        let b = CGFloat(v / Int(powf(256, 0)) % 256) / 255
        self.init(red: r, green: g, blue: b, alpha: min(max(alpha, 0), 1))
    }
    
    convenience init?(hex8: String) {
        let r, g, b, a: CGFloat
        
        if hex8.hasPrefix("#") {
            let start = hex8.index(hex8.startIndex, offsetBy: 1)
            let hexColor = String(hex8[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
    
    func lighterColor(value: CGFloat) -> UIColor {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        guard getHue(&h, saturation: &s, brightness: &b, alpha: &a) else { return self }

        let hsl = hsbToHsl(h: h, s: s, b: b)
        let hsb = hslToHsb(h: hsl.h, s: hsl.s, l: hsl.l + value)

        return UIColor(hue: hsb.h, saturation: hsb.s, brightness: hsb.b, alpha: a)
    }

    func darkerColor(value: CGFloat) -> UIColor {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        guard getHue(&h, saturation: &s, brightness: &b, alpha: &a) else { return self }

        let hsl = hsbToHsl(h: h, s: s, b: b)
        let hsb = hslToHsb(h: hsl.h, s: hsl.s, l: hsl.l - value)

        return UIColor(hue: hsb.h, saturation: hsb.s, brightness: hsb.b, alpha: a)
    }

    private func hsbToHsl(h: CGFloat, s: CGFloat, b: CGFloat) -> (h: CGFloat, s: CGFloat, l: CGFloat) {

        let newH = h
        var newL = (2.0 - s) * b
        var newS = s * b
        newS /= (newL <= 1.0 ? newL : 2.0 - newL)
        newL /= 2.0
        return (h: newH, s: newS, l: newL)
    }

    private func hslToHsb(h: CGFloat, s: CGFloat, l: CGFloat) -> (h: CGFloat, s: CGFloat, b: CGFloat) {
        let newH = h
        let ll = l * 2.0
        let ss = s * (ll <= 1.0 ? ll : 2.0 - ll)
        let newB = (ll + ss) / 2.0
        let newS = (2.0 * ss) / (ll + ss)
        return (h: newH, s: newS, b: newB)
    }
}
