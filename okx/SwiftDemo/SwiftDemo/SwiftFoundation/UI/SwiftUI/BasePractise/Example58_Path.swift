//
//  Example58_Path.swift
//  SwiftDemo
//
//  Created by taojiang on 2026/3/3.
//

import SwiftUI

struct Example58_Path: View {
    
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 100, y: 100))
            path.addCurve(to: CGPoint(x: 100, y: 100), control1: CGPoint(x: 50, y: 50), control2: CGPoint(x: 50, y: 150)
                          )
//            path.addCurve(to: CGPoint(x: 100, y: 100), control1: CGPoint(x: 150, y: 150), control2: CGPoint(x: 150, y: 50)
//            )
            
        }.fill(.red)
        .frame(width: 200, height: 200)
    }
}

#Preview {
    Example58_Path()
}
