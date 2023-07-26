//
//  TimeStretchWatchApp.swift
//  TimeStretchWatch Watch App
//
//  Created by Esad Dursun on 19.07.23.
//

import SwiftUI

@main
struct TimeStretchWatch_Watch_AppApp: App {
    // Set up the ExtensionDelegate as the delegate for the Watch App
    @WKExtensionDelegateAdaptor(ExtensionDelegate.self) var extensionDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
