//
//  ContentView.swift
//  TimeStretch
//
//  Created by Esad Dursun on 09.07.23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var dateTime: String = ""
    
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
                    Text(dateTime)
                        .font(.system(size: 60))
                        .foregroundColor(.white)
                    Text(dateTime)
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                    Text("24h format")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                }
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
        .padding(.vertical, 100)
        .padding(.horizontal, 70)
        .background(.white)
        .onReceive(timer) { _ in
            updateTime()
        }
    }
    
    func updateTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        dateTime = formatter.string(from: Date())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
