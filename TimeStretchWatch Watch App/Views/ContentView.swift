//
//  ContentView.swift
//  TimeStretchWatch Watch App
//
//  Created by Esad Dursun on 19.07.23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var notificationController = NotificationController.shared
    @StateObject var timeController: TimeController = TimeController()
    
    @State private var selectedHourIndex: Int
    @State private var editSelectedHourIndex = false
    @State private var showNotificationsToast = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init() {
        let storedHourIndex = UserDefaults.standard.integer(forKey: selectedHourIndexKey)
        _selectedHourIndex = State(initialValue: storedHourIndex)
    }
    
    var body: some View {
        ZStack {
            Color.purple
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                if !editSelectedHourIndex {
                    Spacer()
                }
                VStack {
                    Text("")
                        .font(.system(size: 13))
                        .foregroundColor(.white)
                        .padding(.top, 1)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    showNotificationsToast = false
                                }
                            }
                        }
                    Text(timeController.adjustedTime.padding(toLength: 8, withPad: "0", startingAt: 0))
                        .font(.system(size: 30, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 3, x: 0, y: 3)
                    Text("in \(timeController.hoursInADayInSelectedTimeSystem)-h Clock")
                        .font(.system(size: 15, design: .monospaced))
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 1, x: 0, y: 3)
                    Text(notificationController.isNotificationsOn ? notificationsActivated : notificationsDeactivated)
                        .font(.system(size: 13))
                        .foregroundColor(.white)
                        .padding(.top, 1)
                        .opacity(showNotificationsToast ? 1.0 : 0.0)
                        .onAppear {
                            if showNotificationsToast {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                    showNotificationsToast = false
                                }
                            }
                        }
                }
                if editSelectedHourIndex {
                    Spacer()
                    SegmentedView($selectedHourIndex, selections: Array(timeController.validHourOptions)) {
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
                                notificationController.scheduleHourlyNotifications(
                                    hoursInADay: timeController.hoursInADayInSelectedTimeSystem,
                                    minutesInAHour: timeController.minutesInAHourInSelectedTimeSystem,
                                    secondsInAMinute: timeController.secondsInAMinuteInSelectedTimeSystem
                                )
                                showNotificationsToast = true
                            }
                        }
                }
            }
            .padding(.horizontal)
        }
        .onReceive(timer) { _ in
            timeController.updateTime()
        }
        .onChange(of: selectedHourIndex) { _ in
            timeController.selectedHourIndex = selectedHourIndex
            notificationController.handleHourSystemChange()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
