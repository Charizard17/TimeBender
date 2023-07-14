//
//  TimeController.swift
//  TimeStretch
//
//  Created by Esad Dursun on 11.07.23.
//

import SwiftUI
import UserNotifications

class TimeController: ObservableObject {
    
    @Published var currentTime: String = ""
    @AppStorage(selectedHourIndexKey) var selectedHourIndex: Int = 3
    
    private var adjustedTimeComponents: DateComponents = DateComponents()
    private var adjustedTimeHours: Int = 0
    private var adjustedTimeMinutes: Int = 0
    private var adjustedTimeSeconds: Int = 0
    
    // in a normal day we have 24 hours and we call it 24-h time system
    // following hour options represents different hour time systems in a day
    // if 16 selected, it means 1 day has 16 hours, 1 hour has 90 minutes, 1 minute has 60 seconds
    // if 48 selected, it means 1 day has 48 hours, 1 hour has 30 minutes, 1 minute has 60 seconds
    let validHourOptions: [Int] = [16, 18, 20, 24, 30, 32, 36, 40, 45, 48]
    
    var hoursInADayInSelectedTimeSystem: Int {
        guard selectedHourIndex >= 0 && selectedHourIndex < validHourOptions.count else {
            return 24
        }
        return validHourOptions[selectedHourIndex]
    }

    var minutesInAHourInSelectedTimeSystem: Int {
        return 1440 / hoursInADayInSelectedTimeSystem
    }
    let secondsInAMinuteInSelectedTimeSystem: Int = 60
    var adjustedTime: String {
        return calculateTimeFromTimeComponents(hour: adjustedTimeHours, minute: adjustedTimeMinutes, second: adjustedTimeSeconds)
    }
    
    let formatter = DateFormatter()
    
    init() {
        formatter.dateFormat = "HH:mm:ss"
        
        updateTime()
        scheduleHourlyNotificationsForAdjustedTime()
    }
    
    func updateTime() {
        let now = Date()
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: now)
        let secondsPassed = Int(now.timeIntervalSince(startOfDay))
        
        // following lines calculate adjusted time hours, minutes and seconds. E.g. if in 24-h time system time is 12:47:34
        // but in 36-h time system it is 19:07:34.With these calculations we get adjustedTimeHours as 19,
        // adjustedTimeMinutes as 07 and adjustedTimeSeconds as 34
        adjustedTimeHours = (secondsPassed / (minutesInAHourInSelectedTimeSystem * secondsInAMinuteInSelectedTimeSystem)) % hoursInADayInSelectedTimeSystem
        var remainingSeconds = secondsPassed - adjustedTimeHours * minutesInAHourInSelectedTimeSystem * secondsInAMinuteInSelectedTimeSystem
        adjustedTimeMinutes = (remainingSeconds / secondsInAMinuteInSelectedTimeSystem) % minutesInAHourInSelectedTimeSystem
        remainingSeconds = remainingSeconds - adjustedTimeMinutes * secondsInAMinuteInSelectedTimeSystem
        adjustedTimeSeconds = remainingSeconds
        
        adjustedTimeComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
        adjustedTimeComponents.hour = adjustedTimeHours
        adjustedTimeComponents.minute = adjustedTimeMinutes
        adjustedTimeComponents.second = adjustedTimeSeconds
        
        currentTime = formatter.string(from: now)
    }
    
    func scheduleHourlyNotificationsForAdjustedTime() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllPendingNotificationRequests()
        
        for i in 0..<hoursInADayInSelectedTimeSystem {
            // adjustedTimeForNotificationContent depends on i index and it can be followings:
            // 00:00:00, 11:00:00, 35:00:00, 46:00:00 etc, depending on the hoursInADayInSelectedTimeSystem
            let adjustedTimeForNotificationContent = "\(String(format: "%02d", i)):00:00"
            
            let triggerComponents = getCurrentTime(adjustedTimeHours: i, adjustedTimeMinutes: 0, adjustedTimeSeconds: 0)
            let triggeredTime = calculateTimeFromTimeComponents(hour: triggerComponents.hour!, minute: triggerComponents.minute!, second: triggerComponents.second!)
            
            // set push-notification content title and body text
            let content = UNMutableNotificationContent()
            content.title = "Hourly Update in \(hoursInADayInSelectedTimeSystem)-h Time System"
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
    
    // get current time from adjusted time. E.g. if in 36-h time system time is 19:07:34
    // but in 24-h time system it is 12:47:34.With these calculations we get adjustedTimeHours as 12,
    // adjustedTimeMinutes as 47 and adjustedTimeSeconds as 34
    func getCurrentTime(adjustedTimeHours: Int, adjustedTimeMinutes: Int, adjustedTimeSeconds: Int) -> DateComponents {
        let secondsPassed = adjustedTimeSeconds + adjustedTimeMinutes * secondsInAMinuteInSelectedTimeSystem + adjustedTimeHours * minutesInAHourInSelectedTimeSystem * secondsInAMinuteInSelectedTimeSystem
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let currentTime = calendar.date(byAdding: .second, value: secondsPassed, to: startOfDay)!
        
        return calendar.dateComponents([.hour, .minute, .second], from: currentTime)
    }
    
    func calculateTimeFromTimeComponents(hour: Int, minute: Int, second: Int) -> String {
        let hour = String(format: "%02d", hour)
        let minute = String(format: "%02d", minute)
        let second = String(format: "%02d", second)
        return "\(hour):\(minute):\(second)"
    }

}
