//
//  Example42_LazyGrid.swift
//  SwiftDemo
//
//  Created by taojiang on 2026/2/28.
//

import SwiftUI

struct Example42_LazyGrid: View {
    let columns = [
        GridItem(.flexible(minimum: 80)),
        GridItem(.flexible(minimum: 80)),
        GridItem(.flexible(minimum: 80)),
    ]
    
    let icons = [
        "heart.fill", "star.fill", "bell.fill",
                "person.fill", "house.fill", "car.fill",
                "phone.fill", "house.fill", "car.fill"
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(Array(icons.enumerated()), id: \.offset) { index, icon in
                    Image(systemName: icon)
                        .font(.largeTitle)
                        .frame(height: 100)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .navigationTitle("grid layout")
    }
}

#Preview {
    Example42_LazyGrid()
}
