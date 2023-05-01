
import Foundation
import CoreLocation
import GoogleMaps

class MapPolygone: GMSPolygon {
    
    var type: ZoneType

    override init() {
        self.type = .unknown
        super.init()
    }
    
    convenience init(path: GMSPath?) {
        self.init()
        self.path = path
        self.type = .unknown
    }
    
    convenience init(path: GMSPath, zoneType: ZoneType) {
        self.init(path: path)
        self.type = zoneType
    }
    
    override func setOnMain(_ map: GMSMapView) {
        self.strokeColor = self.type.strokeColor
        self.fillColor   = self.type.fillColor
        self.strokeWidth = self.type.strokeWidth
        
        DispatchQueue.main.async { [self, map] in
            self.map = map
        }
    }
}


extension GMSPolygon {
    @objc func setOnMain(_ map: GMSMapView) {
        self.strokeColor = .black
        self.fillColor   = .black.withAlphaComponent(0.1)
        self.strokeWidth = 1
        
        DispatchQueue.main.async { [self, map] in
            self.map = map
        }
    }
}

extension MapPolygone {
    
    public enum ZoneType {
        case danger
        case unknown
        
        var fillColor: UIColor {
            switch self {
            case .danger: return .red.withAlphaComponent(0.25)
            case .unknown: return .clear
            }
        }
        var strokeColor: UIColor {
            switch self {
            case .danger: return .red
            case .unknown: return .clear
            }
        }
        var strokeWidth: CGFloat {
            switch self {
            case .danger: return 1.0
            case .unknown: return 0.0
            }
        }
    }
    
}
