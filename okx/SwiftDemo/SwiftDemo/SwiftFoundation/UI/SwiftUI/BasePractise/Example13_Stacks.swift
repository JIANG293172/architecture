//
//  Example12_Stacks.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/2/28.
//

import SwiftUI

struct Example13_Stacks: View {
    var body: some View {
        ZStack {
            Color.blue.opacity(0.2)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Main Title")
                    .font(.largeTitle)
                
                
                HStack(spacing: 10) {
                    Image(systemName: "star.fill")
                    Text("Rating: 5/5")
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
        }
        
    }
}

#Preview {
    Example13_Stacks()
}
