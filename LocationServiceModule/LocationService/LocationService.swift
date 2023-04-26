import Foundation
import CoreLocation

public final class LocationService: NSObject {
    let collector = LocationDelegatesCollector()
    
    lazy var manager: CLLocationManager = {
        var manager = CLLocationManager()
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        return manager
    }()
    
    public static let shared: LocationService = LocationService()

    private override init() {
        super.init()
        print("inited")
        _ = manager
    }
    
}

// MARK: - Main actions
public extension LocationService {
    
    /// Subscribe for updates
    func addDelegate(_ newDelegate: LocationUpdatedDelegate) async throws {
        try await collector.addDelegate(WeakLocationUpdatedDelegate(value: newDelegate))
    }
    
    
    /// Unsubscribe for updates
    func unsubscribe(_ newDelegate: LocationUpdatedDelegate) async throws {
        try await collector.removeDelegate(WeakLocationUpdatedDelegate(value: newDelegate))
    }
    
}


// MARK: - CLLocationManagerDelegate
extension LocationService: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Task(priority: .background) {
            await collector.sendNewInfo(locations.first)
        }
    }
    
}
