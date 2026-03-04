//
//  Example95_ZoonGesture.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/3/4.
//

import SwiftUI

struct Example95_ZoonGesture: View {
    @State var scale = 1.0
    
    var body: some View {
        Circle()
            .scaleEffect(scale)
            .gesture(MagnificationGesture()
                .onChanged({ val in
                    scale = val
                })
            )
    }
}

#Preview {
    Example95_ZoonGesture()
}
