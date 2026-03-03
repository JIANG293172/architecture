//
//  Example45_Menu.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/3/3.
//

import SwiftUI

struct Example45_Menu: View {
    @State private var selectedOption = "None"
    
    var body: some View {
        VStack(spacing: 20) {
            Text("selected option: \(selectedOption)")
                .font(.title)
            
            Menu("actions") {
                Button("option1") {
                    selectedOption = "option 1"
                }
                Button("option2") {
                    selectedOption = "option 2"
                }
                Divider()
                Button("delete", role: .destructive) {
                    selectedOption = "deleted"
                }
            }
            .font(.headline)
            
            Text("long press me")
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(8)
                .contextMenu {
                    Button("copy") { selectedOption = "copiid" }
                    Button("share") { selectedOption = "shared" }
                }
        }
    }
}

