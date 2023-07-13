//
//  TimeController.swift
//  TimeStretch
//
//  Created by Esad Dursun on 11.07.23.
//

import Foundation
import UserNotifications

import Foundation
import UserNotifications

class TimeController: ObservableObject {
    
    @Published var currentTime: String = ""
    @Published var selectedHourIndex: Int
    
    private var adjustedTimeComponents: DateComponents = DateComponents()
    private var adjustedTimeHours: Int = 0
    private var adjustedTimeMinutes: Int = 0
    private var adjustedTimeSeconds: Int = 0
    
    let validHourOptions: [Int] = [16, 18, 20, 24, 30, 32, 36, 40, 45, 48, 1440]
    
    var hours: Int {
        return validHourOptions[selectedHourIndex]
    }
    
    var minutes: Int {
        return 1440 / hours
    }
    
    let seconds: Int = 60
    
    let formatter = DateFormatter()
    
    var adjustedTime: String {
        let hoursString = String(format: "%02d", adjustedTimeHours)
        let minutesString = String(format: "%02d", adjustedTimeMinutes)
        let secondsString = String(format: "%02d", adjustedTimeSeconds)
        return "\(hoursString):\(minutesString):\(secondsString)"
    }
    
    init() {
        formatter.dateFormat = "HH:mm:ss"
        
        let savedIndex = UserDefaults.standard.integer(forKey: "selectedHourIndex")
        selectedHourIndex = validHourOptions.indices.contains(savedIndex) ? savedIndex : 3
        
        updateTime()
        scheduleHourlyNotifications()
    }
    
    func updateTime() {
        let now = Date()
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: now)
        let secondsPassed = Int(now.timeIntervalSince(startOfDay))
        
        adjustedTimeHours = (secondsPassed / (minutes * seconds)) % hours
        var remainingSeconds = secondsPassed - adjustedTimeHours * minutes * seconds
        adjustedTimeMinutes = (remainingSeconds / seconds) % minutes
        remainingSeconds = remainingSeconds - adjustedTimeMinutes * seconds
        adjustedTimeSeconds = remainingSeconds
        
        adjustedTimeComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
        adjustedTimeComponents.hour = adjustedTimeHours
        adjustedTimeComponents.minute = adjustedTimeMinutes
        adjustedTimeComponents.second = adjustedTimeSeconds
        
        currentTime = formatter.string(from: now)
    }
    
    func scheduleHourlyNotifications() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllPendingNotificationRequests()
        
        for i in 1...24 {
            let adjustedHour = (adjustedTimeComponents.hour! + i) % hours
            let adjustedTime = String(format: "%02d:%02d:%02d", adjustedHour, adjustedTimeComponents.minute!, adjustedTimeComponents.second!)
            
            let content = UNMutableNotificationContent()
            content.title = "Hourly Update"
            content.body = "Adjusted Time: \(adjustedTime)"
            content.sound = UNNotificationSound.default
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponentsForAdjustedHour(i), repeats: true)
            
            let request = UNNotificationRequest(identifier: "HourlyNotification\(i)", content: content, trigger: trigger)
            
            notificationCenter.add(request) { error in
                if let error = error {
                    print("Error scheduling hourly notification: \(error)")
                } else {
                    print("Hourly notification scheduled successfully for adjusted time: \(adjustedTime)")
                }
            }
        }
    }

    private func dateComponentsForAdjustedHour(_ hourOffset: Int) -> DateComponents {
        let calendar = Calendar.current
        let now = Date()
        
        var components = calendar.dateComponents([.year, .month, .day, .hour], from: now)
        components.minute = 0
        components.second = 0
        
        let adjustedHoursToAdd = (hours - adjustedTimeComponents.hour! + hourOffset) % hours
        let nextHour = (components.hour! + adjustedHoursToAdd) % hours
        
        components.hour = nextHour
        
        return components
    }
}
