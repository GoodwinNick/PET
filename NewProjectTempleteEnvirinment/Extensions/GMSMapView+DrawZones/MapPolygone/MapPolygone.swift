
import Foundation
import CoreLocation
import GoogleMaps

class MapPolygone: GMSPolygon {
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
        DispatchQueue.main.async { [self, map] in
            self.strokeColor = self.type.strokeColor
            self.fillColor   = self.type.fillColor
            self.strokeWidth = self.type.strokeWidth
            self.map = map
        }

    }
}


extension GMSPolygon {
    @objc func setOnMain(_ map: GMSMapView) {
        DispatchQueue.main.async { [weak self, weak map] in
            self?.map = map
        }
    }
}
