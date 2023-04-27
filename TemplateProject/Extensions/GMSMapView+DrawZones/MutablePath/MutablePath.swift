
import Foundation
import CoreLocation
import GoogleMaps

class MutablePath: GMSMutablePath {
    override init() {
        super.init()
    }
    
    func setPoints(_ points: [CLLocationCoordinate2D]) {
        for point in points {
            self.add(point)
        }
    }
}
