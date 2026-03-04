//
//  Example16_Gradients.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/2/28.
//

import SwiftUI

struct Example16_Gradients: View {
    var body: some View {
        
        VStack {
            Text("Solid Color")
                .frame(height: 80)
                .frame(maxWidth: .infinity)
                .background(.red)
                .foregroundColor(.white)
            
            Text("Linear Gradient")
                .frame(height: 80)
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing)
                )
                .foregroundColor(.white)
            
            Text("Radial Gradient")
                .frame(height: 80)
                .frame(maxWidth: .infinity)
                .background(
                    RadialGradient(
                        gradient: Gradient(colors: [.yellow, .orange]), center: .center, startRadius: 10, endRadius: 100
                    )
                )
                .foregroundColor(.white)
            
        }
    }
}

#Preview {
    Example16_Gradients()
}
