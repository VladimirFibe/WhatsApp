import UIKit
import MapKit
import CoreLocation

final class MapViewController: BaseViewController {
    var location: CLLocation?
    var mapView: MKMapView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
}

extension MapViewController {
    override func setupViews() {
        setupMapView()
        setupTitle()
        setupLeftBarButton()
    }

    func setupMapView() {
        mapView = MKMapView(frame: view.frame)
        mapView.showsUserLocation = true
        if let location {
            mapView.setCenter(location.coordinate, animated: false)
            mapView.addAnnotation(MapAnnotation(title: nil, coordinate: location.coordinate))
        }
        view.addSubview(mapView)
    }

    private func setupLeftBarButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonPressed))
    }

    private func setupTitle() {
        navigationItem.title = "Map View"
    }

    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
}
