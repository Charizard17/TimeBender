//
//  SettingsView.swift
//  TimeStretch
//
//  Created by Esad Dursun on 11.07.23.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var isToggleOn: Bool = true
    
    var body: some View {
        VStack {
            Section(header: Text("Notifications")) {
                VStack {
                    Toggle("Push-notifications", isOn: $isToggleOn)
                    Toggle("Vibration", isOn: $isToggleOn)
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
