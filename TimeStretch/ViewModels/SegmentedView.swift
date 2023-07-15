//
//  SegmentedView.swift
//  TimeStretch
//
//  Created by Esad Dursun on 16.07.23.
//

import SwiftUI

struct SegmentedView: View {
    @Binding var currentIndex: Int
    var selections: [Int]
    var onChange: (() -> Void)?
    
    init(_ currentIndex: Binding<Int>, selections: [Int], onChange: (() -> Void)? = nil) {
        self._currentIndex = currentIndex
        self.selections = selections
        self.onChange = onChange
        
        UISegmentedControl.appearance().selectedSegmentTintColor = .purple
        UISegmentedControl.appearance().backgroundColor = UIColor(Color.purple.opacity(0.3))
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color.white)], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color.secondary)], for: .normal)
    }
    
    var body: some View {
        VStack {
            Picker("", selection: $currentIndex) {
                ForEach(selections.indices, id: \.self) { index in
                    Text("\(selections[index])")
                        .tag(index)
                }
            }
            .pickerStyle(.segmented)
            .tint(.purple)
        }
        .padding()
        .onChange(of: currentIndex, perform: { _ in
            onChange?()
        })
    }
}
