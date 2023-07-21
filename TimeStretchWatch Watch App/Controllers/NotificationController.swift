//
//  NotificationController.swift
//  TimeStretchWatch Watch App
//
//  Created by Esad Dursun on 21.07.23.
//

import SwiftUI
import UserNotifications

class NotificationController: ObservableObject {
    static let shared = NotificationController()
    
    @AppStorage(isNotificationsOnKey) var isNotificationsOn: Bool = true
    
    private init() {}
    
    func scheduleHourlyNotifications(hoursInADay: Int, minutesInAHour: Int, secondsInAMinute: Int) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllPendingNotificationRequests()
        notificationCenter.removeAllDeliveredNotifications()
        
        guard isNotificationsOn else {
            return
        }
        
        for i in 0..<hoursInADay {
            let adjustedTimeForNotificationContent = "\(String(format: "%02d", i)):00:00"
            
            let triggerComponents = TimeUtils.getCurrentTime(
                adjustedTimeHours: i,
                adjustedTimeMinutes: 0,
                adjustedTimeSeconds: 0,
                minutesInAHour: minutesInAHour,
                secondsInAMinute: secondsInAMinute
            )
            
            let triggeredTime = TimeUtils.formatTime(
                hours: triggerComponents.hour!,
                minutes: triggerComponents.minute!,
                seconds: triggerComponents.second!
            )
            
            let content = UNMutableNotificationContent()
            content.title = "Update in \(hoursInADay)-Hour Clock"
            content.body = "Current Time: \(adjustedTimeForNotificationContent)"
            content.sound = UNNotificationSound.defaultCritical
            
            let trigger: UNCalendarNotificationTrigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: true)
            
            let request = UNNotificationRequest(identifier: "HourlyNotification\(i)", content: content, trigger: trigger)
            
            notificationCenter.add(request) { error in
                if let error = error {
                    print("Error scheduling hourly notification: \(error)")
                } else {
                    print("Hourly notification scheduled for adjusted time: \(adjustedTimeForNotificationContent), triggered time: \(triggeredTime)")
                }
            }
        }
    }

    
    func handleHourSystemChange() {
        let timeController = TimeController.shared
        scheduleHourlyNotifications(
            hoursInADay: timeController.hoursInADayInSelectedTimeSystem,
            minutesInAHour: timeController.minutesInAHourInSelectedTimeSystem,
            secondsInAMinute: timeController.secondsInAMinuteInSelectedTimeSystem
        )
    }
}
