//
//  ContentView.swift
//  TimeStretchWatch Watch App
//
//  Created by Esad Dursun on 19.07.23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.purple
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                VStack {
                    Text("33:22:44".padding(toLength: 8, withPad: "0", startingAt: 0))
                        .font(.system(size: 35, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 3, x: 0, y: 3)
                    Text("in 40-h Clock")
                        .font(.system(size: 15, design: .monospaced))
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 1, x: 0, y: 3)
                }
                Spacer()
                HStack {
                    Button(action: {
                        //
                    }) {
                        Image(systemName: "clock.arrow.2.circlepath")
                            .resizable()
                            .frame(width: 30, height: 25)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Button(action: {
                        //
                    }) {
                        Image(systemName: "bell.circle")
                            .resizable()
                            .frame(width: 30, height: 25)
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
