//
//  SettingsView.swift
//  TimeStretch
//
//  Created by Esad Dursun on 11.07.23.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject private var notificationController = NotificationController.shared
    
    var body: some View {
        VStack {
            Section(header: Text("Notifications")) {
                VStack {
                    Toggle("Push", isOn: $notificationController.isPushNotificationsOn)
                        .onChange(of: notificationController.isPushNotificationsOn) { newValue in
                            UserDefaults.standard.set(newValue, forKey: isPushNotificationsOnKey)
                            handleNotificationUpdates()
                        }
                    Toggle("Sound", isOn: $notificationController.isSoundNotificationsOn)
                        .onChange(of: notificationController.isSoundNotificationsOn) { newValue in
                            UserDefaults.standard.set(newValue, forKey: isSoundNotificationsOnKey)
                            handleNotificationUpdates()
                        }
                    Toggle("Vibration", isOn: $notificationController.isVibrationNotificationsOn)
                        .onChange(of: notificationController.isVibrationNotificationsOn) { newValue in
                            UserDefaults.standard.set(newValue, forKey: isVibrationNotificationsOnKey)
                            handleNotificationUpdates()
                        }
                }
            }
            Spacer()
        }
        .padding(.vertical, 50)
        .padding(.horizontal, 50)
        .background(.white)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Settings View")
                    .foregroundColor(.purple)
            }
        }
    }
    
    private func handleNotificationUpdates() {
        let timeController = TimeController.shared
        notificationController.scheduleHourlyNotifications(
            hoursInADay: timeController.hoursInADayInSelectedTimeSystem,
            minutesInAHour: timeController.minutesInAHourInSelectedTimeSystem,
            secondsInAMinute: timeController.secondsInAMinuteInSelectedTimeSystem
        )
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
