//
//  CovidNearMeApp.swift
//  Shared
//
//  Created by Arie Hendrikse on 21/1/21.
//

import SwiftUI
import os

@main

struct CovidNearMeApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var modelData = ModelData()
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(modelData)
                .onAppear {
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (allowed, error) in
                         //This callback does not trigger on main loop be careful
                        if allowed {
                          os_log(.debug, "Allowed") //import os
                        } else {
                          os_log(.debug, "Error")
                        }
                    }
                }
        }
        .onChange(of: scenePhase) { _ in
            persistenceController.save()
        }
    }
}
