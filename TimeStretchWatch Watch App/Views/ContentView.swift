//
//  ContentView.swift
//  TimeStretchWatch Watch App
//
//  Created by Esad Dursun on 19.07.23.
//

import SwiftUI
import WatchKit

struct ContentView: View {
    
    @ObservedObject private var notificationController = NotificationController.shared
    @StateObject var timeController: TimeController = TimeController()
    
    @State private var selectedHourIndex: Int
    @State private var editSelectedHourIndex = false
    @State private var showNotificationsText = false
    @State private var showSelectedHourChangedText = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let isDevice41mm: Bool = WKInterfaceDevice.current().screenBounds.width < 180
    
    init() {
        let storedHourIndex = UserDefaults.standard.integer(forKey: selectedHourIndexKey)
        _selectedHourIndex = State(initialValue: storedHourIndex)
    }
    
    var body: some View {
        ZStack {
            Color.purple
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Spacer()
                    HStack {
                        Text("Time")
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                    }
                    .frame(width: 60)
                    .padding(.trailing, -15)
                    Image(timeStretchLogo2)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                    HStack {
                        Text("Stretch")
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                    }
                    .frame(width: 60)
                    .padding(.leading, -5)
                    Spacer()
                }
                Spacer()
            }
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
                                    showNotificationsText = false
                                }
                            }
                        }
                    Text(timeController.adjustedTime.padding(toLength: 8, withPad: "0", startingAt: 0))
                        .font(.system(size: isDevice41mm ? 25 : 30, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 3, x: 0, y: 3)
                    Text("in \(timeController.hoursInADayInSelectedTimeSystem)-h Clock")
                        .font(.system(size: isDevice41mm ? 13 : 15, design: .monospaced))
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 1, x: 0, y: 3)
                    ZStack {
                        if showNotificationsText {
                            Text(notificationController.isNotificationsOn ? notificationsActivated : notificationsDeactivated)
                                .font(.system(size: isDevice41mm ? 11 : 12))
                                .foregroundColor(.white)
                                .opacity(showNotificationsText ? 1.0 : 0.0)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                        withAnimation {
                                            showNotificationsText = false
                                        }
                                    }
                                }
                        }
                        if showSelectedHourChangedText {
                            ZStack {
                                Color.purple
                                Text("\(timeController.hoursInADayInSelectedTimeSystem)-h Clock selected")
                                    .font(.system(size: isDevice41mm ? 11 : 12))
                                    .foregroundColor(.white)
                                    .opacity(showSelectedHourChangedText ? 1.0 : 0.0)
                                    .onAppear {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                            withAnimation {
                                                showSelectedHourChangedText = false
                                            }
                                        }
                                    }
                            }
                        }
                    }
                }
                if editSelectedHourIndex {
                    Spacer()
                    SegmentedView($selectedHourIndex, selections: Array(timeController.validHourOptions), isDevice41mm: isDevice41mm) {
                        showSelectedHourChangedText = true
                    }
                } else {
                    Spacer()
                }
                HStack {
                    Image(systemName: "clock.arrow.2.circlepath")
                        .resizable()
                        .frame(width: isDevice41mm ? 31 : 36, height: isDevice41mm ? 25 : 30)
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
                        .frame(width: isDevice41mm ? 25 : 30, height: isDevice41mm ? 25 : 30)
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
                                showNotificationsText = true
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
