//
//  ClinicAnnotation.swift
//  CovidNearMe
//
//  Created by Arie Hendrikse on 22/1/21.
//

import Foundation
import SwiftUI
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var image: UIImage
    var color: UIColor
    var title: String?
    var subtitle: String?
    var priority: Int {
        switch exposureType {
            case "monitor":
                return 1
            case "test":
                return 2
            case "isolate":
                return 3
            default:
                return 1
        }
    }
    var type: String
    var ken: KenExposure?
    var exposureType: String?



    init(clinic: Clinic) {
        self.coordinate = clinic.locationCoordinate!
        self.image = clinic.UIimage
        self.title = clinic.Site_Name
        self.color = UIColor(clinic.color)
        self.subtitle = clinic.Suburb
        self.type = "monitor"
    }
    init(monitor: MonitorLocation) {
        let df = DateFormatter()
        df.dateFormat = "dd/MM"
        self.coordinate = monitor.locationCoordinate
        self.image = UIImage(systemName: "binoculars")!
        self.title = df.string(from: monitor.dateFrom ?? Date())
        self.color = .systemPurple
        self.subtitle = "" //need to add suburb stuff
        self.type = "monitor"
    }
    
    init(exposure: Exposure) {
        self.coordinate = exposure.locationCoordinate!
        self.image = exposure.UIimage
        self.title = exposure.Venue
        self.color = UIColor(exposure.color)
        self.subtitle = exposure.Time
        self.type = "exposure"

    }
    init(exposure: KenExposure) {
        self.coordinate = exposure.locationCoordinate!
        self.image = exposure.UIimage
        self.title = exposure.locationName
        self.color = UIColor(exposure.color)
        self.subtitle = exposure.locationSuburb
        self.type = "exposure"
        self.ken = exposure
        self.exposureType = exposure.worstExposure!.exposureType
    }
    init(dummy: DummyPin) {
        self.coordinate = dummy.locationCoordinate
        self.image = UIImage(systemName: "plus")!
        self.title = "Monitor"
        self.color = .systemPurple
        self.type = "dummy"
    }
}


    
    

