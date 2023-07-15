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
            Section {
                VStack {
                    Toggle("Notifications", isOn: $notificationController.isNotificationsOn)
                        .onChange(of: notificationController.isNotificationsOn) { newValue in
                            UserDefaults.standard.set(newValue, forKey: isNotificationsOnKey)
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
