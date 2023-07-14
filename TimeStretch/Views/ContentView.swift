//
//  ContentView.swift
//  TimeStretch
//
//  Created by Esad Dursun on 09.07.23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var timeController: TimeController = TimeController()
    @StateObject var notificationController: NotificationController = NotificationController.shared
    
    @State private var editSelectedHourIndex = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    VStack {
                        HStack {
                            NavigationLink(destination: SettingsView().environmentObject(timeController)) {
                                Image(systemName: "gearshape")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.purple)
                            }
                            Spacer()
                            Image(systemName: "timer")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.purple)
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
                            Image(systemName: "calendar")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.purple)
                        }
                    }
                    ZStack {
                        Rectangle()
                            .foregroundColor(.purple)
                            .shadow(radius: 5)
                            .cornerRadius(100)
                            .frame(height: 250)
                        VStack {
                            Spacer()
                            Text(timeController.currentTime)
                                .font(.system(size: 25))
                                .foregroundColor(.white)
                            Text("\(timeController.hoursInADayInSelectedTimeSystem)h format")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        }
                        .padding(.bottom, 10)
                        VStack(alignment: .leading) {
                            Text(timeController.adjustedTime)
                                .font(.system(size: 65))
                                .foregroundColor(.white)
                                .padding(.bottom, 20)
                        }
                    }
                    .frame(height: 250)
                }
            }
            .padding(.vertical, 50)
            .padding(.horizontal, 50)
            .background(.white)
            .onReceive(timer) { _ in
                timeController.updateTime()
            }
            .onChange(of: timeController.selectedHourIndex) { _ in
                notificationController.handleHourSystemChange()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
