//
//  ContentView.swift
//  TimeStretchWatch Watch App
//
//  Created by Esad Dursun on 19.07.23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var timeController: TimeController = TimeController()
    
    @State private var isBellTapped = false
    
    @State private var editSelectedHourIndex = false
    @State private var selectedHourIndex: Int
    
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
                    Text(timeController.adjustedTime.padding(toLength: 8, withPad: "0", startingAt: 0))
                        .font(.system(size: 30, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 3, x: 0, y: 3)
                    Text("in \(timeController.hoursInADayInSelectedTimeSystem)-h Clock")
                        .font(.system(size: 15, design: .monospaced))
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 1, x: 0, y: 3)
                }
                //                Spacer()
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
                        .frame(width: 30, height: 25)
                        .foregroundColor(.white)
                        .scaleEffect(editSelectedHourIndex ? 1.2 : 1.0)
                        .onTapGesture {
                            editSelectedHourIndex.toggle()
                        }
                    Spacer()
                    Image(systemName: "bell.circle")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(isBellTapped ? .gray : .white)
                        .scaleEffect(isBellTapped ? 0.8 : 1.0)
                        .onTapGesture {
                            isBellTapped.toggle()
                            print("bell circle")
                        }
                }
            }
            .padding(.horizontal)
            .onReceive(timer) { _ in
                timeController.updateTime()
            }
            .onChange(of: selectedHourIndex) { _ in
                timeController.selectedHourIndex = selectedHourIndex
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
