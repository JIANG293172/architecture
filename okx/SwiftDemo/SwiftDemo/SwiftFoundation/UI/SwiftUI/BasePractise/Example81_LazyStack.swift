//
//  Example81_LazyStack.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/3/4.
//

import SwiftUI

struct Example81_LazyStack: View {
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(0..<100) { i in
                    Text("row \(i)")
                }
            }
        }
    }
}

#Preview {
    Example81_LazyStack()
}
