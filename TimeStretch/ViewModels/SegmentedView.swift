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
        
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.white
        UISegmentedControl.appearance().backgroundColor = UIColor(Color.purple.opacity(0.3))
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color.purple)], for: .selected)
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
            .pickerStyle(SegmentedPickerStyle())
        }
        .onChange(of: currentIndex, perform: { _ in
            onChange?()
        })
    }
}

struct SegmentedView_Previews: PreviewProvider {
    @State private static var selectedHourIndex = 1
    
    static var previews: some View {
        SegmentedView($selectedHourIndex, selections: [16, 18, 20, 24, 30, 32, 36, 40, 45, 48])
    }
}
