//
//  Example57_CustomShape.swift
//  SwiftDemo
//
//  Created by taojiang on 2026/3/3.
//

import SwiftUI

struct Example57_Triangle: Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path .addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
    
}

struct Example57_CustomShape: View {
    var body: some View {
        Circle()
            .fill(Color.blue.opacity(0.5))
            .frame(width: 100, height: 100)
        
        
        Example57_Triangle().fill(Color.red.opacity(0.5))
            .frame(width: 100, height: 100)
        
        RoundedRectangle(cornerRadius: 20)
            .stroke(.green, lineWidth: 5)
            .frame(width: 100, height: 100)
    }
}

#Preview {
    Example57_CustomShape()
}
