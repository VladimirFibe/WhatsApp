import UIKit
import MapKit
import CoreLocation
final class MapViewController: BaseViewController {
    var location: CLLocation?
    var mapView: MKMapView!

}

extension MapViewController {
    override func setupViews() {
        setupMapView()
    }

    func setupMapView() {

        mapView = MKMapView(frame: view.frame)
        mapView.showsUserLocation = true

        if let location {
            mapView.setCenter(location.coordinate, animated: false)
//            mapView.addAnnotation(MapAnnotation(title: nil, coordinate: location.coordinate))
        }

        view.addSubview(mapView)
    }


}
