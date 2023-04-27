
import GoogleMaps

extension GMSMapView {
    func drawZones(_ zones: [DangerZone]) {
        for dangerZone in zones {
            let pathZone = MutablePath()
            
            pathZone.setPoints(dangerZone.points)
            let polygonZone = MapPolygone(path: pathZone, zoneType: .danger)
            polygonZone.setOnMain(self)
        }
    }
}
