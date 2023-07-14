//
//  TimeUtils.swift
//  TimeStretch
//
//  Created by Esad Dursun on 14.07.23.
//

import Foundation

class TimeUtils {
    static func formatTime(hours: Int, minutes: Int, seconds: Int) -> String {
        let hour = String(format: "%02d", hours)
        let minute = String(format: "%02d", minutes)
        let second = String(format: "%02d", seconds)
        return "\(hour):\(minute):\(second)"
    }

    static func getCurrentTime(
        adjustedTimeHours: Int,
        adjustedTimeMinutes: Int,
        adjustedTimeSeconds: Int,
        minutesInAHour: Int,
        secondsInAMinute: Int
    ) -> DateComponents {
        let secondsPassed = adjustedTimeSeconds + adjustedTimeMinutes * secondsInAMinute + adjustedTimeHours * minutesInAHour * secondsInAMinute

        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let currentTime = calendar.date(byAdding: .second, value: secondsPassed, to: startOfDay)!

        return calendar.dateComponents([.hour, .minute, .second], from: currentTime)
    }
}
