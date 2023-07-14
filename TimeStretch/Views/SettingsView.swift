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
    
    @StateObject var timeController: TimeController = TimeController()
    
    var body: some View {
        VStack {
            Section(header: Text("Notifications")) {
                VStack {
                    Toggle("Push-notifications", isOn: $isPushNotificationsOn)
                        .onChange(of: isPushNotificationsOn) { newValue in
                            UserDefaults.standard.set(newValue, forKey: isPushNotificationsOnKey)
                            print("push-notifications are: \(isPushNotificationsOn)")
//                            timeController.isPushNotificationsOn = newValue
//                            timeController.scheduleHourlyNotifications()
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
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
