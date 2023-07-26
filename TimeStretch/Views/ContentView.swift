//
//  ContentView.swift
//  TimeStretch
//
//  Created by Esad Dursun on 09.07.23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var notificationController = NotificationController.shared
    @StateObject var timeController: TimeController = TimeController()
    
    @State private var selectedHourIndex: Int
    @State private var editSelectedHourIndex = false
    @State private var showNotificationsToast = false
    @State private var showPickerToast = false
    @State private var showInfoAlert = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init() {
        let storedHourIndex = UserDefaults.standard.integer(forKey: selectedHourIndexKey)
        _selectedHourIndex = State(initialValue: storedHourIndex)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("Time")
                            .font(.system(size: 20, weight: .bold, design: .monospaced))
                            .foregroundColor(.purple)
                    }
                    .frame(width: 100)
                    .padding(.trailing, -10)
                    Image(timeStretchLogo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                    HStack {
                        Text("Stretch")
                            .font(.system(size: 20, weight: .bold, design: .monospaced))
                            .foregroundColor(.purple)
                        Spacer()
                    }
                    .frame(width: 100)
                    .padding(.leading, -10)
                    Spacer()
                }
                .padding(.top, 10)
                ZStack {
                    VStack {
                        HStack {
                            Image(systemName: notificationController.isNotificationsOn ? "bell.circle" : "bell.slash.circle")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.purple)
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
                            Spacer()
                            Button(action: {
                                showInfoAlert = true
                            }) {
                                Image(systemName: "info.circle")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.purple)
                            }
                        }
                        
                        Spacer()
                        if editSelectedHourIndex {
                            VStack {
                                HStack {
                                    AdjustedClockTextView(labelText: "Hours", selectedTimeText: "24 → \(timeController.hoursInADayInSelectedTimeSystem)")
                                    Spacer()
                                    AdjustedClockTextView(labelText: "Minutes", selectedTimeText: "60 → \(timeController.minutesInAHourInSelectedTimeSystem)")
                                    Spacer()
                                    AdjustedClockTextView(labelText: "Seconds", selectedTimeText: "60 → \(timeController.secondsInAMinuteInSelectedTimeSystem)")
                                }
                                SegmentedView($selectedHourIndex, selections: Array(timeController.validHourOptions)) {
                                    showPickerToast = true
                                }
                            }
                            .padding(.bottom, 20)
                        }
                        HStack {
                            Image(systemName: "clock.arrow.2.circlepath")
                                .resizable()
                                .frame(width: 60, height: 50)
                                .foregroundColor(.purple)
                                .rotationEffect(editSelectedHourIndex ? .degrees(180) : .degrees(0))
                                .onTapGesture {
                                    withAnimation(.linear(duration: 0.3)) {
                                        editSelectedHourIndex.toggle()
                                    }
                                }
                            Spacer()
                        }
                    }
                    ZStack {
                        Rectangle()
                            .foregroundColor(.purple)
                            .shadow(radius: 5)
                            .cornerRadius(80)
                            .frame(height: 250)
                            .shadow(color: .gray, radius: 10, x: 0, y: 0)
                        VStack {
                            Spacer()
                            VStack {
                                Text(timeController.adjustedTime.padding(toLength: 8, withPad: "0", startingAt: 0))
                                    .font(.system(size: 60, weight: .bold, design: .monospaced))
                                    .foregroundColor(.white)
                                    .shadow(color: .black, radius: 3, x: 0, y: 3)
                                Text("in \(timeController.hoursInADayInSelectedTimeSystem)-h Clock")
                                    .font(.system(size: 20, design: .monospaced))
                                    .foregroundColor(.white)
                                    .shadow(color: .black, radius: 1, x: 0, y: 3)
                            }
                            .padding(.top, 30)
                            Spacer()
                            VStack {
                                Text(timeController.currentTime)
                                    .font(.system(size: 30, weight: .semibold, design: .monospaced))
                                    .foregroundColor(.white)
                                    .shadow(color: .black, radius: 1, x: 0, y: 3)
                                Text("in 24-h Clock")
                                    .font(.system(size: 20, design: .monospaced))
                                    .foregroundColor(.white)
                                    .shadow(color: .black, radius: 1, x: 0, y: 3)
                            }
                            .padding(.bottom, 10)
                        }
                    }
                    .padding(.bottom, 100)
                    .frame(height: 250)
                }
            }
            .padding(.bottom, 30)
            .padding(.horizontal, 20)
            .background(Color.white)
            .onReceive(timer) { _ in
                timeController.updateTime()
            }
            .onChange(of: selectedHourIndex) { _ in
                timeController.selectedHourIndex = selectedHourIndex
                notificationController.handleHourSystemChange()
            }
            .overlay(
                Group {
                    if showNotificationsToast {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            ToastView(message: notificationController.isNotificationsOn ? notificationsActivated : notificationsDeactivated, duration: 1.2, toastColor: .purple) {
                                showNotificationsToast = false
                            }
                            .offset(y: -200)
                        }
                    }
                    if showPickerToast {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            ToastView(message: "\(timeController.hoursInADayInSelectedTimeSystem)-h Clock selected", duration: 1.2, toastColor: .purple) {
                                showPickerToast = false
                            }
                            .offset(y: -200)
                        }
                    }
                }
            )
            .alert(isPresented: $showInfoAlert) {
                Alert(
                    title: Text(infoTitle),
                    message: Text(infoMessage),
                    dismissButton: .default(Text("Close"))
                )
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
