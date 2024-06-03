//
//  MapView.swift
//  TrackIT
//
//  Created by Raj Shah on 5/1/24.
//
import SwiftUI
import MapKit
import CoreLocation

struct MapView: UIViewRepresentable {
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @Binding var region: MKCoordinateRegion
    @Binding var userLocation: CLLocation?
    var nearbyPlaces: [MKMapItem]?

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        view.setRegion(region, animated: true)
        if let location = userLocation {
            centerCoordinate = location.coordinate
        }
        if let places = nearbyPlaces {
            view.removeAnnotations(view.annotations)
            view.addAnnotations(places.map { $0.placemark })
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }
    }
}
