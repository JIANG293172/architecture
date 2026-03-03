//
//  Example59_Canvas.swift
//  SwiftDemo
//
//  Created by taojiang on 2026/3/3.
//

import SwiftUI

struct Example59_Canvas: View {
    
    var body: some View {
        Canvas { context, size in
            var rectPath = Path(CGRect(x: 20, y: 20, width: size.width-40, height: size.height-40)
            )
            context.stroke(rectPath, with: .color(.blue), lineWidth: 5)
            
            // 手动计算画布中心位置
            let centerX = size.width / 2
            let centerY = size.height / 2
            
            context.draw(
                Text("Canvas Drawing")
                    .font(.title)
                    .foregroundColor(.red),
                at: CGPoint(x: centerX, y: centerY)
            )
            
            var circlePath = Path(ellipseIn: CGRect(x: size.width/2-25, y: size.height/2 + 40, width: 50, height: 50))
            context.fill(circlePath, with: .color(.green))
            
        }
        .frame(width: 300, height: 300)
        .background(.gray.opacity(0.1))
    }
}

#Preview {
    Example59_Canvas()
}
