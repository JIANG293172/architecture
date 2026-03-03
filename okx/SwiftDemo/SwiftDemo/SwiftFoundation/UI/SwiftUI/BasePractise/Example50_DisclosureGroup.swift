//
//  Example50_DisclosureGroup.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/3/3.
//

import SwiftUI

struct Example50_DisclosureGroup: View {
    @State private var showDetail = false
    
    var body: some View {
        VStack(spacing: 20) {
            DisclosureGroup("show details", isExpanded: $showDetail) {
                VStack(spacing: 10) {
                    Text("detail 1: lorem ipsum dolor sit amet")
                    Text("detail 2: consectetur adipiscing edlit")
                    Text("detail 3: sed do eiusmod tempor incididunt")
                }
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(8)
            }
            .font(.headline)
            
            DisclosureGroup("nested group") {
                Text("nested content 1")
                DisclosureGroup("sub group2") {
                    Text("nested content 2")
                }
            }
        }
        .padding()
    }
}

#Preview {
    Example50_DisclosureGroup()
}
