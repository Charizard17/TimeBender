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
    
    @State private var editSelectedHourIndex = false
    @State private var showNotificationsToast = false
    @State private var showPickerToast = false
    @State private var selectedHourIndex = 0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            VStack {
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
                            
                        }
                        
                        Spacer()
                        if editSelectedHourIndex {
                            VStack {
                                SegmentedView($selectedHourIndex, selections: Array(timeController.validHourOptions)) {
                                    showPickerToast = true
                                }
                                .padding(.top, 10)
                            }
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
                            if editSelectedHourIndex {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Hours:     24 ---> \(timeController.hoursInADayInSelectedTimeSystem)")
                                        Text("Minutes:  60 ---> \(timeController.minutesInAHourInSelectedTimeSystem)")
                                        Text("Seconds: 60 ---> \(timeController.secondsInAMinuteInSelectedTimeSystem)")
                                    }
                                }
                            }
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
            .padding(.vertical, 50)
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
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
