
import GoogleMaps

extension GMSMapView {
    
    func drawZones(_ zones: [DangerZone]) {
        zones.forEach {
            let pathZone = MutablePath()
            pathZone.setPoints($0.points)
            let polygonZone = MapPolygone(path: pathZone, zoneType: .danger)
            Task { await polygonZone.setOnMain(self) }
        }
    }
    
}
