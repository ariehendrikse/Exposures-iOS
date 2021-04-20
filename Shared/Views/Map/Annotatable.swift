//
//  Annotatable.swift
//  CovidNearMe
//
//  Created by Arie Hendrikse on 18/2/21.
//

import Foundation
import MapKit

protocol Annotatable {
    var customAnnotation: MKAnnotation { get }
    var asAnnotatable: Annotatable {get}
}

