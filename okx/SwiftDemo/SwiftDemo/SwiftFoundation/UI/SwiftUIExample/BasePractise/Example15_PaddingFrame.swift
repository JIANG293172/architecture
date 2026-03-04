//
//  Example15_PaddingFrame.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/2/28.
//

import SwiftUI

struct Example15_PaddingFrame: View {
    var body: some View {
        Text("Custom Frame")
            .font(.title)
            .foregroundColor(.white)
            .padding(.vertical, 10)
            .padding(.horizontal, 50)
            .frame(width: 251, height: 80)
            .background(.purple)
            .cornerRadius(10)
            .frame(maxWidth: .infinity) /// 约束俯视图占满
        
    }
}

#Preview {
    Example15_PaddingFrame()
}
