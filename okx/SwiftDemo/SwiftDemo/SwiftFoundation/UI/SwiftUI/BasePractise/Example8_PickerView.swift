//
//  Example8_PickerView.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/2/28.
//

import SwiftUI

struct Example8_PickerView: View {
    @State private var selectedFruit = "Apple"
    let fruits = ["Apple", "Banana", "Orange", "Mango"]
    
    var body: some View {
        VStack(spacing: 20) {
            Picker("Select a fruit", selection: $selectedFruit) {
                ForEach(fruits, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.menu)
            .padding()
            
            Text("Favorite Fruit: \(selectedFruit)")
        }
    }
}

#Preview {
    Example8_PickerView()
}
