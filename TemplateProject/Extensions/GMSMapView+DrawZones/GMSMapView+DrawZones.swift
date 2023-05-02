
import GoogleMaps
import CoreLocation

extension GMSMapView {
    
    func drawZones(_ zones: [DangerZone]) async {
        await withTaskGroup(of: Void.self) { group in
            zones.forEach { value in
                group.addTask { await self.addPoints(points: value.points) }
            }
        }
    }
    
    fileprivate func addPoints(points: [CLLocationCoordinate2D]) async {
        let pathZone = MutablePath()
        pathZone.setPoints(points)
        let polygonZone = MapPolygone(path: pathZone, zoneType: .danger)
        polygonZone.setOnMain(self)

    }
}

extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: Int) async throws {
        let duration = UInt64(seconds * 1_000_000_000)
        try await Task.sleep(nanoseconds: duration)
    }
}
