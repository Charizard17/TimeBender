//
//  NotificationController.swift
//  TimeStretch
//
//  Created by Esad Dursun on 14.07.23.
//

import SwiftUI
import UserNotifications

class NotificationController: ObservableObject {
    static let shared = NotificationController()
    
    @AppStorage(isPushNotificationsOnKey) var isPushNotificationsOn: Bool = true
    @AppStorage(isSoundNotificationsOnKey) var isSoundNotificationsOn: Bool = true
    @AppStorage(isVibrationNotificationsOnKey) var isVibrationNotificationsOn: Bool = true
    
    private init() {}
    
    func scheduleHourlyNotifications(hoursInADay: Int, minutesInAHour: Int, secondsInAMinute: Int) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllPendingNotificationRequests()
        
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
            
            if isPushNotificationsOn {
                content.title = "Hourly Update in \(hoursInADay)-h Time System"
                content.body = "Current Time is \(adjustedTimeForNotificationContent)"
            }
            
            if isSoundNotificationsOn {
                content.sound = UNNotificationSound.default
            }
            
            if isVibrationNotificationsOn {
                content.sound = UNNotificationSound.defaultCritical
            }
            
            let trigger: UNCalendarNotificationTrigger? = isPushNotificationsOn ? UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: true) : nil
            
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
