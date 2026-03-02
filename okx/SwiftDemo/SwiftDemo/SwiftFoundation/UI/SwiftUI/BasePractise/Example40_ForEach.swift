//
//  Example40_ForEach.swift
//  SwiftDemo
//
//  Created by taojiang on 2026/2/28.
//

import SwiftUI

struct Example40_ForEach: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                
                ForEach(1...12, id: \.self) { number in
                    Text("\(number)")
                        .frame(width: 80, height: 100)
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
            }
            .padding()
        }
    }
}

#Preview {
    Example40_ForEach()
}
