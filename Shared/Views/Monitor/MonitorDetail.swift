//
//  MonitorDetail.swift
//  CovidNearMe
//
//  Created by Arie Hendrikse on 17/2/21.
//

import SwiftUI

struct MonitorDetail: View {
    var location: Location
    var monitorLocation: MonitorLocation {
        MonitorLocation(fromStorage: location)
    }
    var body: some View {
        Text("hello")
    }
}
