//
//  Example93_TapGesture.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/3/4.
//

import SwiftUI

struct Example93_TapGesture: View {
    @State var color = Color.blue
    
    var body: some View {
        color.frame(width: 100, height: 100)
            .onTapGesture {
                color = .red
            }
    }
}

#Preview {
    Example93_TapGesture()
}
