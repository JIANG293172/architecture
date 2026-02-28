//
//  Example7_StepperView.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/2/28.
//

import SwiftUI

struct Example7_StepperView: View {
    @State private var quantity = 1

    var body: some View {
        VStack(spacing: 20) {
            Stepper("Quantity : \(quantity)", value: $quantity, in: 1...10)
            
            Text("you selected 、\(quantity) items")
        }
        .padding()
        
    }
}

#Preview {
    Example7_StepperView()
}
