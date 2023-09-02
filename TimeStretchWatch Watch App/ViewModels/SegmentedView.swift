//
//  SegmentedView.swift
//  TimeStretchWatch Watch App
//
//  Created by Esad Dursun on 25.07.23.
//

import SwiftUI

struct SegmentedView: View {
    @Binding var currentIndex: Int
    var selections: [Int]
    var onChange: (() -> Void)?
    var isDevice41mm: Bool
    
    init(_ currentIndex: Binding<Int>, selections: [Int], isDevice41mm: Bool, onChange: (() -> Void)? = nil) {
        self._currentIndex = currentIndex
        self.selections = selections
        self.onChange = onChange
        self.isDevice41mm = isDevice41mm
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                ForEach(selections, id: \.self) { selection in
                    Text("\(selection)")
                        .font(.system(size: isDevice41mm ? 16 : 18))
                        .foregroundColor(currentIndex == selections.firstIndex(of: selection) ? .purple : .black)
                        .padding(isDevice41mm ? 4 : 6)
                        .background(currentIndex == selections.firstIndex(of: selection) ? Color.white : Color.gray)
                        .cornerRadius(6)
                        .onTapGesture {
                            currentIndex = selections.firstIndex(of: selection) ?? 0
                            onChange?()
                        }
                }
            }
            .padding(.bottom, 5)
        }
    }
}


struct SegmentedView_Previews: PreviewProvider {
    @State private static var selectedHourIndex = 1
    
    static var previews: some View {
        SegmentedView($selectedHourIndex, selections: [16, 18, 20, 24, 30, 32, 36, 40, 45, 48])
    }
}
