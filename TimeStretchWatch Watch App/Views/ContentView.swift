//
//  ContentView.swift
//  TimeStretchWatch Watch App
//
//  Created by Esad Dursun on 19.07.23.
//

import SwiftUI
import WatchConnectivity

struct ContentView: View {
    @ObservedObject private var notificationController = NotificationController.shared
    @StateObject var timeController: TimeController = TimeController()
    
    @State private var editSelectedHourIndex = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.purple
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                if !editSelectedHourIndex {
                    Spacer()
                }
                VStack {
                    Text(timeController.adjustedTime.padding(toLength: 8, withPad: "0", startingAt: 0))
                        .font(.system(size: 30, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 3, x: 0, y: 3)
                    Text("in \(timeController.hoursInADayInSelectedTimeSystem)-h Clock")
                        .font(.system(size: 15, design: .monospaced))
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 1, x: 0, y: 3)
                }
                if editSelectedHourIndex {
                    Spacer()
                    SegmentedView($timeController.selectedHourIndex, selections: Array(timeController.validHourOptions)) {
                        // toast?
                    }
                } else {
                    Spacer()
                }
                HStack {
                    Image(systemName: "clock.arrow.2.circlepath")
                        .resizable()
                        .frame(width: 36, height: 30)
                        .foregroundColor(.white)
                        .rotationEffect(editSelectedHourIndex ? .degrees(180) : .degrees(0))
                        .onTapGesture {
                            withAnimation(.linear(duration: 0.3)) {
                                editSelectedHourIndex.toggle()
                            }
                        }
                    Spacer()
                    Image(systemName: notificationController.isNotificationsOn ? "bell.circle" : "bell.slash.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                        .rotationEffect(notificationController.isNotificationsOn ? .degrees(360) : .degrees(0))
                        .onTapGesture {
                            withAnimation(.linear(duration: 0.3)) {
                                notificationController.isNotificationsOn.toggle()
                                UserDefaults.standard.set(notificationController.isNotificationsOn, forKey: isNotificationsOnKey)
                            }
                        }
                }
            }
            .padding(.horizontal)
        }
        .onReceive(timer) { _ in
            timeController.updateTime()
        }
        .onChange(of: timeController.selectedHourIndex) { newIndex in
            timeController.selectedHourIndex = timeController.selectedHourIndex
        }
        .onAppear {
            // Make sure to activate the WCSession when the ContentView appears.
            WCSession.default.activate()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
