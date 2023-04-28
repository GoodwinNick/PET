import UIKit
import GoogleMaps
import LocationService
import GoogleMapsCore
import GoogleMapsBase
import GooglePlaces

class MainViewController: BaseViewController<MainViewModel> {
    @IBOutlet fileprivate weak var mapView: GMSMapView! { didSet { mapViewSettings() } }
    
}


// MARK: - Standard overriding
extension MainViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        Task(priority: .background) { await addLocationDelegate() }
    }
}


// MARK: - UI
extension MainViewController {
    
    override func configUI() {
        super.configUI()
        self.title = "Main"
    }
    
    override func configColors() {
        super.configColors()
        self.view.setBGColor(.background)
    }
    
    override func configStrings() {
        super.configStrings()
    }
}


// MARK: MainView
extension MainViewController: MainView {
    func draw(zones: [DangerZone]) {
        let latitude  = zones.first?.points.first?.latitude  ?? 0.0
        let longitude = zones.first?.points.first?.longitude ?? 0.0
        
        let cameraPosition = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 14)
        
        let cameraUpdate = GMSCameraUpdate.setCamera(cameraPosition)
        
        DispatchQueue.main.async {
            self.mapView.animate(with: cameraUpdate)
        }
        
         self.mapView.drawZones(zones) 
    }
}


// MARK: - LocationUpdatedDelegate
extension MainViewController: LocationUpdatedDelegate {
    var locationDelegateId: String {
        "MainViewController"
    }
    
    func locationUpdated(location: CLLocation) {
        
    }
    
}


// MARK: - Helpers
extension MainViewController {
    func addLocationDelegate() async {
        do {
            try await LocationService.shared.addDelegate(self)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func mapViewSettings() {
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
}

// MARK: - Test Features
extension MainViewController {
    
    // TODO: Need to delete. Only TEST function
    func avoidRoute() {
        
        let path = GMSMutablePath()
        path.add(CLLocationCoordinate2DMake(37.785, -122.396))
        path.add(CLLocationCoordinate2DMake(37.779, -122.392))
        path.add(CLLocationCoordinate2DMake(37.765, -122.391))
        path.add(CLLocationCoordinate2DMake(37.761, -122.397))
        
        let polygon = GMSPolygon(path: path)
        polygon.fillColor = UIColor.red
        polygon.strokeColor = UIColor.black
        polygon.strokeWidth = 2
        polygon.map = mapView
        
        let routePath = GMSMutablePath()
        routePath.add(CLLocationCoordinate2DMake(37.785, -122.396))
        routePath.add(CLLocationCoordinate2DMake(37.779, -122.392))
        routePath.add(CLLocationCoordinate2DMake(37.765, -122.391))
        routePath.add(CLLocationCoordinate2DMake(37.761, -122.397))
        
        let route = GMSPolyline(path: routePath)
        route.strokeWidth = 3
        route.strokeColor = UIColor.blue
        route.map = mapView
        
    }
}
