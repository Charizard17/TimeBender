//
//  ToastView.swift
//  TimeStretch
//
//  Created by Esad Dursun on 15.07.23.
//

import SwiftUI

struct ToastView: View {
    let message: String
    let duration: Double
    let toastColor: Color
    let completion: () -> Void
    
    @State private var isShowing = false
    
    var body: some View {
        Text(message)
            .foregroundColor(.white)
            .padding()
            .background(toastColor)
            .cornerRadius(10)
            .opacity(isShowing ? 1 : 0)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isShowing = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isShowing = false
                    }
                    completion()
                }
            }
    }
}
