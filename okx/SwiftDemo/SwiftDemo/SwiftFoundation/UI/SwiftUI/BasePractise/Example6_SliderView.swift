//
//  Example6_SliderView.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/2/28.
//

import SwiftUI

struct Example6_SliderView: View {
    @State private var volum = 0.0
    
    var body: some View {
        VStack(spacing: 200) {
            Slider(value: $volum, in: 0...100, step: 1) {
                Text("volume")
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {
                Text("100")
            }
        }
        .padding()
        
        Text("current volum \(volum)")
        
    }
}

#Preview {
    Example6_SliderView()
}
