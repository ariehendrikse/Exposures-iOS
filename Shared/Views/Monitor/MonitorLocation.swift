//
//  MonitorLocation.swift
//  CovidNearMe (iOS)
//
//  Created by Arie Hendrikse on 17/2/21.
//

import Foundation
import MapKit
import CoreData
import SwiftUI

struct MonitorLocation: Identifiable, Annotatable {
    //should init from core data model class for monitor

    init (locationCoordinate: CLLocationCoordinate2D, radius: Double) {
        self.locationCoordinate = locationCoordinate
        self.radius = radius
    }
    init (fromStorage loc0: Location) {
        self.id = UUID()
        self.dateFrom = loc0.dateStart
        self.dateTo = loc0.dateEnd
        self.locationCoordinate = CLLocationCoordinate2D(latitude: loc0.latitude, longitude: loc0.longitude)
        self.radius = loc0.radius
    }
    var customAnnotation: MKAnnotation {
        return CustomAnnotation(monitor: self)
    }

    var asAnnotatable: Annotatable {
        get {self as Annotatable}
        set {self = newValue as! Self}
    }
    
    var id: UUID = UUID()
    var dateFrom: Date?
    var dateTo: Date?
    var locationCoordinate: CLLocationCoordinate2D
    var radius: Double?
    var color: Color = Color.purple
    

}
