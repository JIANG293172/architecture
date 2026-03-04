//
//  Example17_Divider.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/2/28.
//

import SwiftUI

struct Example17_Divider: View {
    var body: some View {
        VStack {
            Text("Section 1")
                .padding()
            
            Divider()
                .background(.gray)
                .padding(.horizontal)
            
            Text("Section 2")
                .padding()
            
        }
    }
}

#Preview {
    Example17_Divider()
}
