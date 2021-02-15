//
//  ClinicListView.swift
//  Clinics
//
//  Created by Arie Hendrikse on 21/1/21.
//

import SwiftUI
import MapKit
import CoreLocation

extension CLLocation {
    
    /// Get distance between two points
    ///
    /// - Parameters:
    ///   - from: first point
    ///   - to: second point
    /// - Returns: the distance in meters
    class func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return from.distance(from: to)
    }
}

struct ClinicListView: View {
    @EnvironmentObject var modelData: ModelData

    @State private var showFavoritesOnly = false
    
    @ObservedObject var locationViewModel = LocationViewModel()

//    var filteredClinics: [Clinic] {
//        modelData.clinics.filter { clinic in
//                (!showFavoritesOnly || clinic.isFavorite)
//            }
//        }
    var body: some View {
        NavigationView {
            List {
                MapContainer(locations: modelData.clinics.filter({ (clinic) -> Bool in
                    clinic.locationCoordinate != nil
                })
                .map({ (clinic) -> ClinicAnnotation in
                    ClinicAnnotation(clinic: clinic)
                    
                }))
                    .frame(height: 300)
                    .clipped()
                    .listRowInsets(EdgeInsets())
                Toggle(isOn: $showFavoritesOnly) {
                    Text("Favorites only")
                }
                ForEach(modelData.clinics.sorted(by: { (clinic1, clinic2) -> Bool in
                    let userLocation = CLLocationCoordinate2D(latitude: locationViewModel.userLatitude, longitude: locationViewModel.userLongitude )
                    let distance1 = CLLocation.distance(from: userLocation, to: clinic1.locationCoordinate!)
                    let distance2 = CLLocation.distance(from: userLocation, to: clinic2.locationCoordinate!)
                    return distance1 < distance2
                })) { clinic in
                NavigationLink(destination: ClinicDetail(clinic: clinic)) {
                    ClinicRow(clinic: clinic)
                    }
                }
            }
            .navigationTitle("Clinics")

        }
        .navigationViewStyle(StackNavigationViewStyle())

    }
}

struct ClinicListView_Previews: PreviewProvider {
    static var previews: some View {
            ClinicListView()
                .environmentObject(ModelData())
        }
}
