//
//  CovidNearMeApp.swift
//  Shared
//
//  Created by Arie Hendrikse on 21/1/21.
//

import SwiftUI

@main
struct CovidNearMeApp: App {
    //let persistenceController = PersistenceController.shared
    @StateObject private var modelData = ModelData()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
    }
}
