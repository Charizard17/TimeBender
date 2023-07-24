//
//  ContentView.swift
//  TimeStretchWatch Watch App
//
//  Created by Esad Dursun on 19.07.23.
//

import SwiftUI

struct ContentView: View {
    @State private var isClockArrowTapped = false
    @State private var isBellTapped = false

    var body: some View {
        ZStack {
            Color.purple
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                VStack {
                    Text("33:22:44".padding(toLength: 8, withPad: "0", startingAt: 0))
                        .font(.system(size: 30, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 3, x: 0, y: 3)
                    Text("in 40-h Clock")
                        .font(.system(size: 15, design: .monospaced))
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 1, x: 0, y: 3)
                }
                Spacer()
                HStack {
                    Image(systemName: "clock.arrow.2.circlepath")
                        .resizable()
                        .frame(width: 30, height: 25)
                        .foregroundColor(isClockArrowTapped ? .gray : .white)
                        .scaleEffect(isClockArrowTapped ? 0.8 : 1.0)
                        .onTapGesture {
                            isClockArrowTapped.toggle()
                            print("clock arrow 2")
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
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
