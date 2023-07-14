//
//  SettingsView.swift
//  TimeStretch
//
//  Created by Esad Dursun on 11.07.23.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage(isPushNotificationsOnKey) private var isPushNotificationsOn: Bool = true
    @State private var isVibrationOn = true
    
    var body: some View {
        VStack {
            Section(header: Text("Notifications")) {
                VStack {
                    Toggle("Push-notifications", isOn: $isPushNotificationsOn)
                        .onChange(of: isPushNotificationsOn) { newValue in
                            UserDefaults.standard.set(newValue, forKey: isPushNotificationsOnKey)
                            print("push-notifications are: \(isPushNotificationsOn)")
                            handleNotificationUpdates()
                        }
                    Toggle("Vibration", isOn: $isVibrationOn)
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
        let notificationController = NotificationController.shared
        notificationController.isPushNotificationsOn = isPushNotificationsOn
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
