//
//  Example20_Group.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/2/28.
//

import SwiftUI

struct Example20_Group: View {
    var body: some View {
        Group {
            Text("Line 1")
            Text("Line 2")
            Text("Line 3")
        }
        .font(.subheadline)
        .foregroundColor(.gray)
        
        Group {
            Text("Line4")
            Text("line5")
            Text("line6")
        }
        .font(.subheadline)
        .foregroundColor(.blue)
    }
    
}

#Preview {
    Example20_Group()
}
