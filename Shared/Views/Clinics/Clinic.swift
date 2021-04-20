//
//  Landmark.swift
//  Landmarks
//
//  Created by Arie Hendrikse on 21/1/21.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit

struct Clinic: Hashable, Codable, Identifiable {
    var id: String {
        return Site_Name + String((Geometry?.latitude)!) + ", " + String((Geometry?.longitude)!)
    }
    var Site_Name: String
    var Facility: String
    var Website: String?
    var Phone: String?
    var Site_Facilities: String?
    var Service_Availability: String?
    var Address: String
    var Suburb: String
    var State: String
    var Postcode: String
    var LGA: String
    var delaytext: String?
    var Requirements: String?
    var mapAnnotation:  MapAnnotationProtocol  { return MapAnnotation(coordinate: locationCoordinate!, anchorPoint: CGPoint(x: 0.5, y: 0.5)) {
        Circle()
            .strokeBorder(Color.red, lineWidth: 10)
            .frame(width: 44, height: 44)
        }
    }
    var addressByName: String {
        let trailing: String = ", " + self.Suburb + ", " + self.State
        var s = self.Address
        if self.Address.contains("(") {
            s = s.substring(to: self.Address.firstIndex(of: "(")!)
        }
        while s.contains(",")
        {
            s = s.substring(from: s.lastIndex(of: ",")!)
            s.remove(at: s.firstIndex(of: ",")!)
        }
        return s + trailing
    }
    //"Symptomatic testing only": String
    var Directions: String?


    private var Geometry: Geo?
    var locationCoordinate: CLLocationCoordinate2D? {
        if ((Geometry?.latitude) != nil) {
            return CLLocationCoordinate2D(
                latitude: Double((Geometry?.latitude!)!),
                longitude: Double((Geometry?.longitude!)!))
        }
        else {
            //add to locations unable to be found
            return CLLocationCoordinate2D(
                latitude:0,
                longitude: 0)
        }
    }
        
    var color: Color { return Color.green }
    var image: Image {
        let x =  Facility.lowercased()
        return
            x.contains("gp") ?
                Image("doctor")
            : x.contains("drive") ?
                Image(systemName: "car")
            : x.contains("hospital") ?
                Image( "hospital")
            : x.contains("pathology") ?
                Image( "blood")
            :
                Image( "empty-test-tube")
        
    }
    var UIimage: UIImage {
        let x =  Facility.lowercased()
        return
            x.contains("gp") ?
            UIImage(named: "doctor")!
            : x.contains("drive") ?
            UIImage(systemName: "car")!
            : x.contains("hospital") ?
            UIImage(named: "hospital")!
            : x.contains("pathology") ?
            UIImage( named: "blood")!
            :
            UIImage(named: "empty-test-tube")!
        
    }
    struct Geo: Codable, Hashable {
      var _id: String?
      var address: String?
      var longitude: Double?
      var latitude: Double?
    }
}
