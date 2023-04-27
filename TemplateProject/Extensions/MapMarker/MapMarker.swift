import UIKit
import GoogleMaps
import CoreLocation

class MapMarker: GMSMarker {
    let id: String
    
    init(position: CLLocationCoordinate2D) {
        self.id = "\(position)"
        super.init()
        self.position = position
    }
}
