//
//  Example26_Enviroment.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/2/28.
//

import SwiftUI

struct Example26_Enviroment: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.horizontalSizeClass) var sizeClass
    @Environment(\.dismiss) var dismiss
    

    var body: some View {
        VStack(spacing: 20) {
            Text("color scheme \(colorScheme == .dark ?  "dark" : "light")")
            
            Text("size class: \(sizeClass == .compact ? "compact" : "regular")")
            
            Button("dismiss (simulate)") {
                dismiss()
            }
            .padding()
            .background(.red)
            .foregroundColor(.white)
            .cornerRadius(8)
                
        }
    }
}

#Preview {
    Example26_Enviroment()
}
