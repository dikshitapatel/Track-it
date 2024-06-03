//
//  LocationManager.swift
//  TrackIT
//
//  Created by Raj Shah on 5/1/24.
//
import SwiftUI
import MapKit
import CoreLocation


class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var userLocation: CLLocation?
    @Published var nearbyPlaces: [MKMapItem]?

    private var locationManager = CLLocationManager()

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
            findNearbyPlaces()
        case .denied, .restricted:
            showLocationAccessDeniedAlert()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location
        findNearbyPlaces()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }

    private func showLocationAccessDeniedAlert() {
        let alert = UIAlertController(
            title: "Location Access Denied",
            message: "Please enable location services for this app in Settings to use this feature.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        })
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
    }

    private func findNearbyPlaces() {
        guard let userLocation = userLocation else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "bank"
        request.region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 8047, longitudinalMeters: 8047) // 5 miles in meters
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                print("Error occurred in search: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self.nearbyPlaces = response.mapItems
        }
    }
}
