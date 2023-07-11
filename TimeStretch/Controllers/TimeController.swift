//
//  TimeController.swift
//  TimeStretch
//
//  Created by Esad Dursun on 11.07.23.
//

import Foundation

class TimeController: ObservableObject {
    
    @Published var currentTime: String = ""
    @Published var selectedHourIndex: Int {
        didSet {
            UserDefaults.standard.set(selectedHourIndex, forKey: "selectedHourIndex")
        }
    }
    
    private var adjustedHours: Int = 0
    private var adjustedMinutes: Int = 0
    private var adjustedSeconds: Int = 0
    
    var validHourOptions: [Int] {
        return [16, 18, 20, 24, 30, 32, 36, 40, 45, 48]
    }
    var hours: Int {
        return validHourOptions[selectedHourIndex]
    }
    var minutes: Int {
        return 1440 / hours
    }
    let seconds: Int = 60
    
    var adjustedTime: String {
        return String(format: "%02d:%02d:%02d", adjustedHours, adjustedMinutes, adjustedSeconds)
    }
    
    init() {
        let savedIndex = UserDefaults.standard.integer(forKey: "selectedHourIndex")
        selectedHourIndex = (savedIndex != 0) ? savedIndex : 3
    }
    
    func updateTime() {
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let secondsPassed = Int(now.timeIntervalSince(startOfDay))
        
        adjustedHours = (secondsPassed / (minutes * seconds)) % hours
        var remainingSeconds = secondsPassed - adjustedHours * minutes * seconds
        adjustedMinutes = (remainingSeconds / seconds) % minutes
        remainingSeconds = remainingSeconds - adjustedMinutes * seconds
        adjustedSeconds = remainingSeconds
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        currentTime = formatter.string(from: now)
    }
}
