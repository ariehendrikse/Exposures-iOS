//
//  MapViewFindButton.swift
//  CovidNearMe
//
//  Created by Arie Hendrikse on 18/2/21.
//

import SwiftUI
import MapKit
struct MapViewFindButton: View {
    @Binding var locations: [Annotatable]
    @State var findLocation = false
    @Binding var region: MKCoordinateRegion
    @Binding var isActive: Bool
    @Binding var didChange: Bool
    @Binding var selectedAnnotation: KenExposure?
    @ObservedObject var locationViewModel = LocationViewModel()
    var body: some View {

        
        MapView( locations: $locations, regionBinding: $region, findLocation: $findLocation,isActive: $isActive, selectedAnnotation: $selectedAnnotation, didChange: $didChange)
        .listRowInsets(EdgeInsets())
        .frame(height: 300)
        .overlay(CurrentLocationButton(findLocation: $findLocation)
            .frame(width: 25, height: 25, alignment: .topLeading)
                    .padding().padding(.trailing, 30), alignment: .topTrailing)
        
    }
}

