
import Foundation
import CoreLocation

struct DangerZone: Sendable, Codable {
    private let zonePoints: [Zone]
    
    var points: [CLLocationCoordinate2D] {
        return zonePoints.map { $0.CLPoint }
    }
    
    enum CodingKeys: String, CodingKey {
        case zonePoints = "zone"
    }
}

struct Zone: Codable {
    private let latitude, longitude: Double
    
    var CLPoint:  CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
}


