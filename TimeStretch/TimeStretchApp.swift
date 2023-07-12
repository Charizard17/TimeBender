//
//  TimeStretchApp.swift
//  TimeStretch
//
//  Created by Esad Dursun on 09.07.23.
//

import SwiftUI
import UserNotifications

@main
struct TimeStretchApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        requestNotificationAuthorization()
        return true
    }
    
    func requestNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Notification authorization error: \(error.localizedDescription)")
            } else {
                print("Notification authorization granted")
            }
        }
    }
    
}
