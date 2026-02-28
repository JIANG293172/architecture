//
//  Example21_State.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/2/28.
//

import SwiftUI

struct Example21_State: View {
    @State private var count = 0
    
    var body: some View {
        VStack {
            Text("count \(count)")
                .font(.title)
            
            Button("increment") {
                count += 1
            }
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            
        }
        
    }
}

#Preview {
    Example21_State()
}
