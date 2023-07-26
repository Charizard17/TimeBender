//
//  AppDelegate.swift
//  TimeStretchWatch Watch App
//
//  Created by Esad Dursun on 26.07.23.
//

import WatchKit
import UserNotifications

class ExtensionDelegate: NSObject, WKExtensionDelegate, UNUserNotificationCenterDelegate {
    func applicationDidFinishLaunching() {
        print("ExtensionDelegate applicationDidFinishLaunching")
        requestNotificationAuthorization()
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

    // UNUserNotificationCenterDelegate methods

    func didReceive(_ notification: UNNotification) {
        // This method is called when a notification is received while the watch app is running in the foreground.
        // You can handle the notification here if needed.
    }
}
