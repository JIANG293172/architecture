//
//  Example31_CustomBinding.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/2/28.
//

import SwiftUI

struct Example31_CustomBinding: View {
    @State private var rawValue = ""
    
    var filteredBinding: Binding<String> {
        Binding(
            get: {rawValue},
            set: { newValue in
                rawValue = newValue.filter{ $0.isNumber }
            }
        )
    }
    
    var body: some View {
        TextField("enter number only" ,text: filteredBinding)
            .padding()
            .border(Color.gray)
            .keyboardType(.numberPad)
    }
}

#Preview {
    Example31_CustomBinding()
}
