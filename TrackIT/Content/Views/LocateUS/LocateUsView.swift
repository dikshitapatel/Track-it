//
//  LocateUsView.swift
//  TrackIT
//
//  Created by Vrushali Shah on 4/17/24.
//

import SwiftUI
import MapKit
import CoreLocation

struct LocateUsView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        VStack {
            MapView(centerCoordinate: $region.center, region: $region, userLocation: $locationManager.userLocation, nearbyPlaces: locationManager.nearbyPlaces)
                .edgesIgnoringSafeArea(.all)

            Button("Find Banks near my location") {
                if let userLocation = locationManager.userLocation {
                    region.center = userLocation.coordinate
                }
            }
            .padding()
        }
    }
}

