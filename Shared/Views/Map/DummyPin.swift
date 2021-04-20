//
//  DummyPin.swift
//  CovidNearMe (iOS)
//
//  Created by Arie Hendrikse on 19/2/21.
//

import Foundation
import MapKit

//struct DummyPin: Identifiable, Annotatable {
//    var id: UUID = UUID()
//    var locationCoordinate: CLLocationCoordinate2D
//
//    var customAnnotation: MKAnnotation = CustomAnnotation(dummy: self)
//
//    var asAnnotatable: Annotatable {
//        get {self as Annotatable}
//        set {self = newValue as! Self}
//    }
//}

struct DummyPin:  Identifiable, Annotatable {
    var id: UUID = UUID()
    var locationCoordinate: CLLocationCoordinate2D
    
    
    var customAnnotation: MKAnnotation {
        return CustomAnnotation(dummy: self)
    }

    var asAnnotatable: Annotatable {
        get {self as Annotatable}
        set {self = newValue as! Self}
    }
    
    
}
