//
//  Example54_Animation.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/3/3.
//

import SwiftUI

struct Example54_Animation: View {
    @State private var scale = 1.0
    @State private var rotation = 0.0
    @State private var opacity = 1.0
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "heart.fill")
                .font(.largeTitle)
                .foregroundColor(.red)
                .scaleEffect(scale)
                .rotationEffect(.degrees(rotation))
                .opacity(opacity)
                .animation(.easeInOut(duration: 0.5), value: scale)
            
            HStack(spacing: 20) {
                Button("scale") {
                    scale = scale == 1.0 ? 1.5 : 1.0
                    
                }
                
                Button("rotate") {
                    rotation += 90
                }
                
                Button("fade") {
                    opacity = opacity == 1.0 ? 0.5 : 1.0
                }
                
            }
        }
    }
}

#Preview {
    Example54_Animation()
}
