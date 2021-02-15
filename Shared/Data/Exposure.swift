//
//  Landmark.swift
//  Landmarks
//
//  Created by Arie Hendrikse on 21/1/21.
//

import Foundation
import SwiftUI
import CoreLocation

struct Exposure: Hashable, Codable, Identifiable {
    var id: String {
        return Venue + Lon + ", " + Lat  + Time
    }
    
    var Venue: String
    var Address: String
    var Suburb: String
    var Date: String
    var Time: String
    var Alert: String
    var Lon: String
    var Lat: String
    var HealthAdviceHTML: String
    private var Geometry: Geo?
//    var action: Action
//        enum Action: String, CaseIterable, Codable {
//            case lakes = "Lakes"
//            case rivers = "Rivers"
//            case mountains = "Mountains"
//        }
    var locationCoordinate: CLLocationCoordinate2D? {
        if ((Geometry?.latitude) != nil) {
            return CLLocationCoordinate2D(
                latitude: Double((Geometry?.latitude!)!),
                longitude: Double((Geometry?.longitude!)!))
        }
        else {
            return CLLocationCoordinate2D(
                latitude: Double((Lat))!,
                longitude: Double((Lon))!)
        }
    }
        
    var image: Image {
        let x =  Alert.lowercased()
        return
            x.contains("14 days") ?
                Image("home-14")
            : x.contains("until you get a negative result") ?
                Image("empty-test-tube")
            :
                Image(systemName: "eye")
    }
    var UIimage: UIImage {
        let x =  Alert.lowercased()
        return
            x.contains( "14 days") ?
            UIImage(named: "home-14")!
            : x.contains("until you get a negative result") ?
            UIImage(named: "empty-test-tube")!
            :
            UIImage(systemName: "eye")!
    }
    var color: Color {
        let x =  Alert.lowercased()
        return
            x.contains("14 days") ?
            Color.red
            : x.contains("until you get a negative result") ?
            Color.yellow
            :
            Color.blue
        
    }
    
    struct Geo: Codable, Hashable {
      var _id: String?
      var address: String?
      var longitude: Double?
      var latitude: Double?
    }
}
