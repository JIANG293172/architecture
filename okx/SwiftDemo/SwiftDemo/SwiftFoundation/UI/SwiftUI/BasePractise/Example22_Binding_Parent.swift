//
//  Example22_Binding_Parent.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/2/28.
//

import SwiftUI

struct Example22_Binding_Parent: View {
    @State private var isOn = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("parent state: \(isOn ? "on" : "off")")
            
            Example22_ChildView(isOn: $isOn)
        }
    }
}

struct Example22_ChildView: View {
    @Binding var isOn: Bool
    
    var body: some View {
        Toggle("child toggle", isOn: $isOn)
            .padding()
            .background(.gray.opacity(0.1))
            .cornerRadius(8)
    }
}

#Preview {
    Example22_Binding_Parent()
}
