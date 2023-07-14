//
//  TimeController.swift
//  TimeStretch
//
//  Created by Esad Dursun on 11.07.23.
//

import SwiftUI

class TimeController: ObservableObject {
    static let shared = TimeController()
    
    @Published var currentTime: String = ""
    @AppStorage(selectedHourIndexKey) var selectedHourIndex: Int = 3

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

    var adjustedTime: String {
        return TimeUtils.formatTime(hours: adjustedTimeHours, minutes: adjustedTimeMinutes, seconds: adjustedTimeSeconds)
    }

    let formatter = DateFormatter()

    init() {
        formatter.dateFormat = "HH:mm:ss"

        updateTime()
        NotificationController.shared.scheduleHourlyNotifications(hoursInADay: hoursInADayInSelectedTimeSystem, minutesInAHour: minutesInAHourInSelectedTimeSystem, secondsInAMinute: secondsInAMinuteInSelectedTimeSystem)
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

        currentTime = formatter.string(from: now)
    }
}
