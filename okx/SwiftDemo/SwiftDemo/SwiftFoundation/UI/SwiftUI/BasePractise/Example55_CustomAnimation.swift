//
//  Example55_CustomAnimation.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/3/3.
//

import SwiftUI

struct Example55_CustomAnimation: View {
    @State private var isAnimating = false

    var body: some View {
        Circle()
            .fill(Color.blue) // 直接在 Circle 上调用 fill
            .frame(width: 100, height: 100) // 定义尺寸
            .scaleEffect(isAnimating ? 1.5 : 1.0)
            .opacity(isAnimating ? 0.5 : 1.0)
            .animation(
                // Custom animation: repeat forever, autoreverse
                Animation.easeInOut(duration: 1)
                    .repeatForever(autoreverses: true),
                value: isAnimating // 添加 value 参数，符合 SwiftUI 3.0+ 语法
            )
            .onAppear {
                isAnimating = true
            }
    }
}

#Preview {
    Example55_CustomAnimation()
}
