//
//  Example64_BindingCustom.swift
//  SwiftDemo
//
//  Created by taojiang on 2026/3/3.
//

import SwiftUI

struct Example64_BindingCustom: View {
    @State private var isOn = false
    
    var body: some View {
        VStack {
            Text(isOn ? "enabled" : "disalbed")
            Example64_CustomToggle(isOn: $isOn)
        }
    }
}

struct Example64_CustomToggle: View {
    @Binding var isOn: Bool
    
    var body: some View {
        Toggle("switch", isOn: $isOn)
    }
}

#Preview {
    Example64_BindingCustom()
}
