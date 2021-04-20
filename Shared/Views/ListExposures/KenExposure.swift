//
//  Landmark.swift
//  Landmarks
//
//  Created by Arie Hendrikse on 21/1/21.
//

import Foundation
import SwiftUI
import MapKit
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
struct KenExposure: Hashable, Codable, Identifiable, Annotatable {
    
    
    func sameLocation( as monitor: MonitorLocation) -> Bool {
        if let radius = monitor.radius {
            let distance0 = CLLocation.distance(from: monitor.locationCoordinate, to: locationCoordinate!)
            return distance0 <= radius
        }
        else {
            return true // change this to work out suburbs matching
        }

    }
    
    var customAnnotation: MKAnnotation {
        return CustomAnnotation(exposure: self)
    }

    var asAnnotatable: Annotatable {
        get {self as Annotatable}
        set {self = newValue as! Self}
    }
    
    
    
    static func closestToUser(between exp0: KenExposure, and exp1: KenExposure, from location: CLLocationCoordinate2D) -> Bool {
            let userLocation = location
            let distance1 = CLLocation.distance(from: userLocation, to: exp0.locationCoordinate!)
            let distance2 = CLLocation.distance(from: userLocation, to: exp1.locationCoordinate!)
            return distance1 < distance2
    }
    
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
    var worstExposure: Alert?  {
        let isolateExposures = exposures.filter({ (alert) -> Bool in alert.exposureType == "isolate"})
        let negativeExposures = exposures.filter({ (alert) -> Bool in alert.exposureType == "negative"})
        let monitorExposures = exposures.filter({ (alert) -> Bool in alert.exposureType == "monitor"})
        let furtherExposures = exposures.filter({ (alert) -> Bool in alert.exposureType == "further"})

        if  furtherExposures.count > 0 {
            //need to add feature where it is also the most recent exposure
            return furtherExposures[0]
        }
        if  isolateExposures.count > 0 {
            //need to add feature where it is also the most recent exposure
            return isolateExposures[0]
        }
        if negativeExposures.count > 0 {
            return negativeExposures[0]
        }
        else if monitorExposures.count > 0 {
            return monitorExposures[0]
        }
        return exposures[0]
    }
    var locationCoordinate: CLLocationCoordinate2D? {
        return CLLocationCoordinate2D(
            latitude: Double((geom.latitude)),
            longitude: Double((geom.longitude)))
    }
    var mapAnnotation:  MapAnnotationProtocol  { return MapAnnotation(coordinate: locationCoordinate!, anchorPoint: CGPoint(x: 0.5, y: 0.5)) {
        Circle()
            .strokeBorder(Color.red, lineWidth: 10)
            .frame(width: 44, height: 44)
        }
    }
    var image: Image {
        switch worstExposure?.exposureType {
            case "isolate":
                return Image("home-14")
            case "negative":
                return Image("empty-test-tube")
            case "monitor":
                return Image("eye")
            case "further":
                return Image(systemName: "house")
            default:
                return Image(systemName: "house")
        }
    }

    var UIimage: UIImage {
        switch worstExposure?.exposureType {
            case "isolate":
                return UIImage(named: "home-14")!

            case "negative":
                return UIImage(named: "empty-test-tube")!
            case "monitor":
                return UIImage(systemName: "eye")!
            case "further":
                return UIImage(systemName: "house")!
            default:
                return UIImage(systemName: "house")!
        }
    }
    var color: Color {
        worstExposure?.color ?? Color.orange
    }
    var UIcolor: UIColor {
        UIColor(self.color)
    }
    
    struct KenGeo: Codable, Hashable {
        var type: String
        var coordinates: [Double]
        var latitude: Double {
            coordinates[1]
        }
        var longitude: Double {
            coordinates[0]
        }
    }
    struct Alert: Codable, Hashable, Identifiable {

        
        func overlaps(with monitor: MonitorLocation) -> Bool {
            return (monitor.dateFrom! <= self.endTime) && (monitor.dateTo! >= self.startTime)
        }
        
        var date: Date {
            let d = DateFormatter()
            d.dateFormat = "yyyy-MM-dd"
            return d.date(from: exposureDate!)!
        }
        var startTime: Date {
            let d = DateFormatter()
            d.dateFormat = "HH:mm:ss'T'yyy-MM-dd"
            return d.date(from: exposureStartTime+"T"+exposureDate!)!
        }
        var endTime: Date {
            let d = DateFormatter()
            d.dateFormat = "HH:mm:ss'T'yyy-MM-dd"
            //print("Here " + exposureEndTime+"T"+exposureDate!)
            return d.date(from: exposureEndTime+"T"+exposureDate!)!
        }
        
        var id: String {
            return exposureUuid
        }
        var color: Color {
            switch exposureType {
                case "isolate":
                    return Color.red
                case "negative":
                    return Color.yellow
                case "monitor":
                    return Color.blue
                case "further":
                    return Color.red
                default:
                    return Color.orange
            }
        }
        var exposureHealthInfoHtml: String
        var alertDescription: String
        var dateDescription: String
        var timeDescription: String
        var exposureStatus: String
        var exposureType: String
        var exposureDate: String?
        var exposureStartTime: String
        var exposureEndTime: String
        var exposureFirstPublishedAt: String?
        var dismissed: Bool?
        var notes: String?
        var exposureUuid: String
        var createdAt: String
        var createdString: String {
            let d = DateFormatter()
            let d0 = DateFormatter()
            d.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            d0.dateStyle = .short
            if let day = d.date(from: createdAt.substring(to: String.Index(encodedOffset: 19)))  {
                return d0.string(from: day)
            }
            return ""
        }
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
        var exposureDate: String?
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
