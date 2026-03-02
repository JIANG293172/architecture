//
//  Example43_ScrollView.swift
//  SwiftDemo
//
//  Created by taojiang on 2026/2/28.
//

import SwiftUI

struct Example43_ScrollView: View {
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                ForEach(1...20, id: \.self) { number in
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.purple.opacity(0.5))
                        .frame(height: 100)
                        .overlay(Text("card \(number)")
                            .font(.title))
                }
            }
                .padding()
        }
        .navigationTitle("custom scrollview")
    }
}

#Preview {
    Example43_ScrollView()
}
