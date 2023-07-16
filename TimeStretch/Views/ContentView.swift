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
                    Image(timeStretchLogo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                    Spacer()
                }
                .padding(.top, 10)
                ZStack {
                    VStack {
                        HStack {
                            Image(systemName: notificationController.isNotificationsOn ? "bell.fill" : "bell.slash.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.purple)
                                .onTapGesture {
                                    notificationController.isNotificationsOn.toggle()
                                    UserDefaults.standard.set(notificationController.isNotificationsOn, forKey: isNotificationsOnKey)
                                    notificationController.scheduleHourlyNotifications(
                                        hoursInADay: timeController.hoursInADayInSelectedTimeSystem,
                                        minutesInAHour: timeController.minutesInAHourInSelectedTimeSystem,
                                        secondsInAMinute: timeController.secondsInAMinuteInSelectedTimeSystem
                                    )
                                    showNotificationsToast = true
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
                                    VStack(alignment: .leading) {
                                        Label("Hours", systemImage: "clock")
                                        Text("24 → \(timeController.hoursInADayInSelectedTimeSystem)")
                                            .font(.system(size: 15))
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    VStack(alignment: .leading) {
                                        Label("Minutes", systemImage: "clock")
                                        Text("60 → \(timeController.minutesInAHourInSelectedTimeSystem)")
                                            .font(.system(size: 15))
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    VStack(alignment: .leading) {
                                        Label("Seconds", systemImage: "clock")
                                        Text("60 → \(timeController.secondsInAMinuteInSelectedTimeSystem)")
                                            .font(.system(size: 15))
                                            .foregroundColor(.gray)
                                    }
                                }
                                SegmentedView($selectedHourIndex, selections: Array(timeController.validHourOptions)) {
                                    showPickerToast = true
                                }
                            }
                            .padding(.bottom, 20)
                        }
                        HStack {
                            Button(action: {
                                editSelectedHourIndex.toggle()
                            }) {
                                Image(systemName: "pencil")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.purple)
                                
                            }
                            Spacer()
                        }
                    }
                    ZStack {
                        Rectangle()
                            .foregroundColor(.purple)
                            .shadow(radius: 5)
                            .cornerRadius(80)
                            .frame(height: 200)
                        VStack {
                            Text(timeController.currentTime)
                                .font(.system(size: 25, design: .monospaced))
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(timeController.hoursInADayInSelectedTimeSystem)-h Clock")
                                .font(.system(size: 20, design: .monospaced))
                                .foregroundColor(.white)
                        }
                        .padding(.bottom, 10)
                        Text(timeController.adjustedTime.padding(toLength: 8, withPad: "0", startingAt: 0))
                            .font(.system(size: 65, weight: .semibold, design: .monospaced))
                            .foregroundColor(.white)
                    }
                    .frame(height: 200)
                }
            }
            .padding(.bottom, 30)
            .padding(.horizontal, 20)
            .background(.white)
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
