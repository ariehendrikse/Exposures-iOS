//
//  PlacementMap.swift
//  CovidNearMe
//
//  Created by Arie Hendrikse on 17/2/21.
//

import SwiftUI
import MapKit

struct PlacementMap: View {
    @Binding var region: MKCoordinateRegion
    @Binding var marker: [Annotatable]
    @Binding var isActive: Bool
    @Binding var selectedAnnotation: KenExposure?
    @Binding var didChange: Bool

    var body: some View {
        MapViewFindButton(locations: $marker, region: $region, isActive: $isActive, didChange: $didChange, selectedAnnotation: $selectedAnnotation)

    }
}

