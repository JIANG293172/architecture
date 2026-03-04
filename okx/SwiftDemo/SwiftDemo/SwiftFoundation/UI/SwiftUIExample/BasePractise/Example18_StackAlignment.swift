//
//  Example18_StackAlignment.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/2/28.
//

import SwiftUI

struct Example18_StackAlignment: View {
    var body: some View {
        VStack(alignment: .center) {
            Text("title")
                .font(.title)
            
            Text("subtitle")
                .font(.subheadline)
            
            Spacer()
            
            HStack(alignment: .center) {
                Image(systemName: "bell")
                Text("notification message with multiple lines")
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
    }
    
    
}

#Preview {
    Example18_StackAlignment()
}
