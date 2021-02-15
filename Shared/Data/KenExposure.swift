//
//  Landmark.swift
//  Landmarks
//
//  Created by Arie Hendrikse on 21/1/21.
//

import Foundation
import SwiftUI
import CoreLocation

struct Header: Hashable, Codable {
    var time: Float
    var schemaName: String
    var schemaVersion: Float
    var file: String
}
struct KenLocation: Hashable, Codable, Identifiable {
    var id: String {
        return String(header.time)
    }
    
    var header: Header
    var locations: [KenExposure]
}
struct KenExposure: Hashable, Codable, Identifiable {
    var id: String {
        return locationUuid
    }
    
    var locationUuid: String
    var locationName: String
    var locationAddress: String
    var locationSuburb: String
    var locationState: String
    var locationLga: String
    var geom: KenGeo
    var exposures: [Alert]
//    var action: Action
//        enum Action: String, CaseIterable, Codable {
//            case lakes = "Lakes"
//            case rivers = "Rivers"
//            case mountains = "Mountains"
//        }
    var worstExposure: Alert  {
        let isolateExposures = exposures.filter({ (alert) -> Bool in alert.exposureType == "isolate"})
        let negativeExposures = exposures.filter({ (alert) -> Bool in alert.exposureType == "negative"})
        let monitorExposures = exposures.filter({ (alert) -> Bool in alert.exposureType == "monitor"})
        if  isolateExposures.count > 0 {
            //need to add feature where it is also the most recent exposure
            return isolateExposures[0]
        }
        if negativeExposures.count > 0 {
            return negativeExposures[0]
        }
        else  {
            return monitorExposures[0]
        }
    }
    var locationCoordinate: CLLocationCoordinate2D? {
        return CLLocationCoordinate2D(
            latitude: Double((geom.latitude)),
            longitude: Double((geom.longitude)))
    }
        
    var image: Image {
        switch worstExposure.exposureType {
            case "isolate":
                return Image("home-14")
            case "negative":
                return Image("home-14")
            default:
                return Image(systemName: "eye")
        }
    }
    var UIimage: UIImage {
        switch worstExposure.exposureType {
            case "isolate":
                return UIImage(named: "home-14")!

            case "negative":
                return UIImage(named: "empty-test-tube")!
            default:
                return UIImage(systemName: "eye")!
        }
    }
    var color: Color {
        switch worstExposure.exposureType {
            case "isolate":
                return Color.red
            case "negative":
                return Color.yellow
            default:
                return Color.blue
        }
    }
    
    struct KenGeo: Codable, Hashable {
        var type: String
        var coordinates: [Double]
        var latitude: Double {
            coordinates[0]
        }
        var longitude: Double {
            coordinates[1]
        }
    }
    struct Alert: Codable, Hashable {
        var alertDescription: String
        var dateDescription: String
        var timeDescription: String
        var exposureStatus: String
        var exposureType: String
        var exposureDate: String
        var exposureStartTime: String
        var exposureEndTime: String
        var exposureFirstPublishedAt: String?
        var dismissed: Bool?
        var notes: String?
        var exposureUuid: String
        var createdAt: String
        var updatedAt: String
        var version: Int
        var history: [AlertHistory]
        
    }
    struct AlertHistory: Codable, Hashable {
        var alertDescription: String
        var dateDescription: String
        var timeDescription: String
        var exposureStatus: String
        var exposureType: String
        var exposureDate: String
        var exposureStartTime: String
        var exposureEndTime: String
        var exposureFirstPublishedAt: String?
        var dismissed: Bool?
        var notes: String?
        var exposureHistoryUuid: String
        var updatedAt: String
        var version: Int
        
    }
}
