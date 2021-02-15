//
//  ClinicMap.swift
//  CovidNearMe
//
//  Created by Arie Hendrikse on 22/1/21.
//

import SwiftUI
import MapKit

struct ClinicMap: View {
    @EnvironmentObject var modelData: ModelData

    var body: some View {
        MapContainer(locations: modelData.clinics.filter({ (clinic) -> Bool in
            clinic.locationCoordinate != nil
        })
        .map({ (clinic) -> ClinicAnnotation in
            return ClinicAnnotation(clinic: clinic)
        }))
            .frame(height: 300)
            .clipped()
            .listRowInsets(EdgeInsets())

    }
}

struct ClinicMap_Previews: PreviewProvider {
    static var previews: some View {
        ClinicMap()
    }
}
