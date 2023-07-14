//
//  NotificationController.swift
//  TimeStretch
//
//  Created by Esad Dursun on 14.07.23.
//

import SwiftUI
import UserNotifications

class NotificationController {
    static let shared = NotificationController()

    @AppStorage(isPushNotificationsOnKey) var isPushNotificationsOn: Bool = true

    private init() {}

    func scheduleHourlyNotifications(hoursInADay: Int, minutesInAHour: Int, secondsInAMinute: Int) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllPendingNotificationRequests()

        guard isPushNotificationsOn else {
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
            content.title = "Hourly Update in \(hoursInADay)-h Time System"
            content.body = "Current Time is \(adjustedTimeForNotificationContent)"
            content.sound = UNNotificationSound.default

            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: true)

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
}
