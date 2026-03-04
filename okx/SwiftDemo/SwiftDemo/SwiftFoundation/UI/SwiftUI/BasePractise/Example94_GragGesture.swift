//
//  Example94_GragGesture.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/3/4.
//

import SwiftUI

struct Example94_GragGesture: View {
    @State var offset = CGSize.zero
    
    var body: some View {
        Circle()
            .offset(offset)
            .gesture(
                DragGesture()
                    .onChanged({ val in
                        offset = val.translation
                    })
            )
    }
}

#Preview {
    Example94_GragGesture()
}
