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
    @State private var showToast = false
    
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
                                    showToast = true
                                }
                            Spacer()
                            
                        }
                        
                        Spacer()
                        
                        if editSelectedHourIndex {
                            VStack {
                                Picker(selection: $timeController.selectedHourIndex, label: Text("Hours")) {
                                    ForEach(0..<timeController.validHourOptions.count, id: \.self) { index in
                                        Text("\(timeController.validHourOptions[index])").tag(index)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Hours: 24 ---> \(timeController.hoursInADayInSelectedTimeSystem)")
                                        Text("Minutes: 60 ---> \(timeController.minutesInAHourInSelectedTimeSystem)")
                                        Text("Seconds: 60 ---> \(timeController.secondsInAMinuteInSelectedTimeSystem)")
                                    }
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
                            Text("\(timeController.hoursInADayInSelectedTimeSystem)-h clock")
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
            .onChange(of: timeController.selectedHourIndex) { _ in
                notificationController.handleHourSystemChange()
            }
            .overlay(
                Group {
                    if showToast {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            ToastView(message: notificationController.isNotificationsOn ? notificationsActivated : notificationsDeactivated, duration: 2.0, toastColor: .purple) {
                                showToast = false
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
