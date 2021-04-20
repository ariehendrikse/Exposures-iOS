//
//  MapContainer.swift
//  CovidNearMe
//
//  Created by Arie Hendrikse on 22/1/21.
//

import SwiftUI
import MapKit

struct MonitorMapContainer: View {
    @Binding var locations: [MonitorLocation]
    
    
    @EnvironmentObject var modelData: ModelData
    @ObservedObject var locationViewModel = LocationViewModel()
    @Binding var region: MKCoordinateRegion

    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: locations){place -> MapMarker in
            MapMarker(coordinate: place.locationCoordinate, tint: place.color)

//            MapAnnotation(coordinate: place.locationCoordinate!) {
//                    ZStack {
//                        Circle()
//                            .onTapGesture(perform: {
//
//                            })
//                            .overlay(Circle()
//                                        .strokeBorder(Color.gray,lineWidth:1))
//                            .frame(width: 15, height: 15, alignment: .center)
//                            .foregroundColor(place.color)
//                    }
//
//            }
        }
//            .overlay(
//                CurrentLocationButton(
//                    region: $region)
//                        .frame(width: 35, height: 35, alignment: .center)
//                        .padding(),
//                alignment: .topTrailing)
    
    }
}

