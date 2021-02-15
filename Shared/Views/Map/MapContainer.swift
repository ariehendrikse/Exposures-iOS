//
//  MapContainer.swift
//  CovidNearMe
//
//  Created by Arie Hendrikse on 22/1/21.
//

import SwiftUI
import MapKit

struct MapContainer: View {
    var locations: [ClinicAnnotation]

    @ObservedObject var locationViewModel = LocationViewModel()
    @State private var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 25.7617,
                longitude: 80.1918
            ),
            span: MKCoordinateSpan(
                latitudeDelta: 10,
                longitudeDelta: 10
            )
        )

        var body: some View {
            VStack {
                Map(coordinateRegion: $region)

                Button("zoom") {
                    withAnimation {
                        region.span = MKCoordinateSpan(
                            latitudeDelta: 100,
                            longitudeDelta: 100
                        )
                    }
                }
            }
        }
}


