//
//  AppDelegate.swift
//  CovidNearMe
//
//  Created by Arie Hendrikse on 17/2/21.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    private func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        // Configure the user interactions first.
        self.configureUserInteractions()
        
        // Register with APNs
        UIApplication.shared.registerForRemoteNotifications()
    }
     
    // Handle remote notification registration.
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
        // Forward the token to your provider, using a custom method.
        self.enableRemoteNotificationFeatures()
        self.forwardTokenToServer(token: deviceToken)
        print(deviceToken)
    }
     
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // The token is not currently available.
        print("Remote notification support is unavailable due to error: \(error.localizedDescription)")
        self.disableRemoteNotificationFeatures()
    }
    func disableRemoteNotificationFeatures() {
        
    }
    
    func forwardTokenToServer(token: Data) {
        
    }
    func enableRemoteNotificationFeatures() {
        
    }
    func configureUserInteractions() {
        
    }
}
