//
//  ClinicAnnotation.swift
//  CovidNearMe
//
//  Created by Arie Hendrikse on 22/1/21.
//

import Foundation
import SwiftUI
import MapKit

class ClinicAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var image: UIImage
    var color: UIColor
    var title: String?
    var subtitle: String?


    init(clinic: Clinic) {
        self.coordinate = clinic.locationCoordinate!
        self.image = clinic.UIimage
        self.title = clinic.Site_Name
        self.color = UIColor(clinic.color)
        self.subtitle = clinic.Suburb
    }
    
    init(exposure: Exposure) {
        self.coordinate = exposure.locationCoordinate!
        self.image = exposure.UIimage
        self.title = exposure.Venue
        self.color = UIColor(exposure.color)
        self.subtitle = exposure.Time
    }
    init(exposure: KenExposure) {
        self.coordinate = exposure.locationCoordinate!
        self.image = exposure.UIimage
        self.title = exposure.locationName
        self.color = UIColor(exposure.color)
        self.subtitle = exposure.locationSuburb
    }
    
}
