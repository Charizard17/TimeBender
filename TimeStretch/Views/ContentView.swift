//
//  ContentView.swift
//  TimeStretch
//
//  Created by Esad Dursun on 09.07.23.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var timeController: TimeController = TimeController()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "gearshape")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.purple)
                Spacer()
                Image(systemName: "timer")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.purple)
            }
            Spacer()
            ZStack {
                Circle()
                    .foregroundColor(.purple)
                    .shadow(radius: 5)
                VStack {
                    Text(timeController.adjustedTime)
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                    Text(timeController.currentTime)
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                    Text("\(timeController.hours)h format")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                }
            }
            VStack {
                Picker(selection: $timeController.selectedHourIndex, label: Text("Hours")) {
                    ForEach(0..<timeController.validHourOptions.count, id: \.self) { index in
                        Text("\(timeController.validHourOptions[index])").tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Hours: 24 ---> \(timeController.hours)")
                        Text("Minutes: 60 ---> \(timeController.minutes)")
                        Text("Seconds: 60 ---> \(timeController.seconds)")
                    }
                }
                .padding(.top, 10)
            }
            Spacer()
            HStack {
                Image(systemName: "pencil")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.purple)
                Spacer()
                Image(systemName: "calendar")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.purple)
            }
        }
        .padding(.vertical, 50)
        .padding(.horizontal, 50)
        .background(.white)
        .onReceive(timer) { _ in
            timeController.updateTime()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
