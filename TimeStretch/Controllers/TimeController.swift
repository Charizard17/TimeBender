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
    @AppStorage("selectedHourIndex") var selectedHourIndex: Int = 3
    
    private var adjustedTimeComponents: DateComponents = DateComponents()
    private var adjustedTimeHours: Int = 0
    private var adjustedTimeMinutes: Int = 0
    private var adjustedTimeSeconds: Int = 0
    
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
    
    let formatter = DateFormatter()
    
    var adjustedTime: String {
        let hoursString = String(format: "%02d", adjustedTimeHours)
        let minutesString = String(format: "%02d", adjustedTimeMinutes)
        let secondsString = String(format: "%02d", adjustedTimeSeconds)
        return "\(hoursString):\(minutesString):\(secondsString)"
    }
    
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
            let adjustedHourForNotificationContent = String(format: "%02d", i)
            let adjustedTimeForNotificationContent = "\(adjustedHourForNotificationContent):00:00"
            
            let triggerComponents = getCurrentTime(adjustedTimeHours: i, adjustedTimeMinutes: 0, adjustedTimeSeconds: 0)
            
            let triggeredHour = String(format: "%02d", triggerComponents.hour!)
            let triggeredMinute = String(format: "%02d", triggerComponents.minute!)
            let triggeredSecond = String(format: "%02d", triggerComponents.second!)
            let triggeredTime = "\(triggeredHour):\(triggeredMinute):\(triggeredSecond)"
            
            let content = UNMutableNotificationContent()
            content.title = "Hourly Update"
            content.body = "Adjusted Time: \(adjustedTimeForNotificationContent)"
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
    
    func getCurrentTime(adjustedTimeHours: Int, adjustedTimeMinutes: Int, adjustedTimeSeconds: Int) -> DateComponents {
        let secondsPassed = adjustedTimeSeconds + adjustedTimeMinutes * secondsInAMinuteInSelectedTimeSystem + adjustedTimeHours * minutesInAHourInSelectedTimeSystem * secondsInAMinuteInSelectedTimeSystem
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let currentTime = calendar.date(byAdding: .second, value: secondsPassed, to: startOfDay)!
        
        return calendar.dateComponents([.hour, .minute, .second], from: currentTime)
    }

}
