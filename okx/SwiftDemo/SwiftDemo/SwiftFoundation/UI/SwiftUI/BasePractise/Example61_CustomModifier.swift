//
//  Example61_CustomModifier.swift
//  SwiftDemo
//
//  Created by taojiang on 2026/3/3.
//

import SwiftUI

struct Example61_PrimaryButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.padding()
            .background(.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .shadow(radius: 5)
    }
}

extension View {
    func primaryButtonStyle() -> some View {
        self.modifier(Example61_PrimaryButtonModifier())
    }
}

struct Example61_CustomModifier: View {
    var body: some View {
        VStack(spacing: 20) {
            Button("primary button 1") {
                
            }
            .primaryButtonStyle()
            
            Button("primary button 2") {
                
            }.primaryButtonStyle()
        }
        
        
    }
}

#Preview {
    Example61_CustomModifier()
}
