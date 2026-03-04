//
//  Example9_ListView.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/2/28.
//

import SwiftUI

struct Example9_ListView: View {
    let items = ["Item1", "Item2", "Item3", "Item4", "Item5"]
    
    var body: some View {
        List(items, id: \.self) { item in
            Text(item)
                .padding()
        }
        .listStyle(.plain)
        .navigationTitle("Basic List")
    }
    
}

#Preview {
    Example9_ListView()
}
