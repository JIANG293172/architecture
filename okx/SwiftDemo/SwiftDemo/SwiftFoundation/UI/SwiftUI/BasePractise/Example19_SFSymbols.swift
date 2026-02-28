//
//  Example19_SFSymbols.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/2/28.
//

import SwiftUI

struct Example19_SFSymbols: View {
    var body: some View {
        
        VStack(spacing: 30) {
            Image(systemName: "heart.fill")
                .font(.largeTitle)
                .foregroundColor(.red)
            
            Image(systemName: "arrow.right.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.blue)
            
            Image(systemName: "person.circle")
                .symbolVariant(.fill)
                .font(.system(size: 60))
                .foregroundColor(.green)
            
            
        }
        .padding()
        
    }
}

#Preview {
    Example19_SFSymbols()
}
