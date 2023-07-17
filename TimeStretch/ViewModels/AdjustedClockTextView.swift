//
//  AdjustedClockTextView.swift
//  TimeStretch
//
//  Created by Esad Dursun on 17.07.23.
//

import SwiftUI

struct AdjustedClockTextView: View {
    let labelText: String
    let selectedTimeText: String
    var body: some View {
        VStack(alignment: .leading) {
            Label(labelText, systemImage: "clock")
                .font(.system(size: 16, design: .monospaced))
                .foregroundColor(.gray)
            Text(selectedTimeText)
                .font(.system(size: 20, weight: .bold, design: .monospaced))
                .foregroundColor(.purple)
        }
    }
}
