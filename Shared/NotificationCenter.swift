//
//  NotificationCenter.swift
//  CovidNearMe
//
//  Created by Arie Hendrikse on 17/2/21.
//

import Foundation
import UIKit

class NotificationCenter: NSObject, ObservableObject {
    var dumbData: UNNotificationResponse?
    override init() {
       super.init()
       UNUserNotificationCenter.current().delegate = self
    }
}
extension NotificationCenter: UNUserNotificationCenterDelegate  {
    
   func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) { }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        dumbData = response
}
  func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) { }
}
