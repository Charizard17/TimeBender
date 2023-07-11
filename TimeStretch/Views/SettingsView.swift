//
//  SettingsView.swift
//  TimeStretch
//
//  Created by Esad Dursun on 11.07.23.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var isPushNotificationsOn: Bool = true
    @State private var isVibrationOn: Bool = true
    
    var body: some View {
        VStack {
            Section(header: Text("Notifications")) {
                VStack {
                    Toggle("Push-notifications", isOn: $isPushNotificationsOn)
                    Toggle("Vibration", isOn: $isVibrationOn)
                }
            }
            Spacer()
        }
        .padding(.vertical, 50)
        .padding(.horizontal, 50)
        .background(.white)
        .toolbar{
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
