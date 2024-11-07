//
//  MapView.swift
//  Sales
//
//  Created by José Ruiz on 29/7/24.
//

import Foundation
import MapKit
import SwiftUI

struct MapView: View {
    @State private var location: CLLocationCoordinate2D?
    var onMapViewActionClicked: (_ location: CLLocationCoordinate2D) -> Void
    
    @State private var startPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 56, longitude: -3), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)))
    
    var body: some View {
        MapReader { proxy in
            Map(initialPosition: startPosition) {
                if let location = location {
                    Marker(coordinate: location) {
                        Text("Point")
                    }
                }
            }
            .onTapGesture { position in
                if let coordinate = proxy.convert(position, from: .local) {
                    location = coordinate
                    onMapViewActionClicked(location ?? CLLocationCoordinate2D())
                }
            }
        }
    }
    
    init(location: CLLocationCoordinate2D? = nil, onMapViewActionClicked: @escaping (_: CLLocationCoordinate2D) -> Void) {
        _location = State(initialValue: location)
        self.onMapViewActionClicked = onMapViewActionClicked
        _startPosition = State(wrappedValue: MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location?.latitude ?? -0.187944, longitude: location?.longitude ?? -78.487616), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))))
    }
}
