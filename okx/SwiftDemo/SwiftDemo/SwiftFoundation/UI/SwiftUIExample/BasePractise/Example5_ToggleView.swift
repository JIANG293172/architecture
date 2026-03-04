//
//  Example5_ToggleView.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/2/28.
//

import SwiftUI

struct Example5_ToggleView: View {
    @State private var isDarkMode = false
    
    var body: some View {
        Toggle(isOn: $isDarkMode) {
            Text("Dark Mode")
                .font(.headline)
        }
        .padding()
        .background(isDarkMode ? Color.black : Color.white)
        .foregroundColor(isDarkMode ? Color.white : Color.black)
        .cornerRadius(8)
        .padding(.horizontal)
    }
}

#Preview {
    Example5_ToggleView()
}
