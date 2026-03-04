//
//  Example29_AppStorage.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/2/28.
//

import SwiftUI

struct Example29_AppStorage: View {
    @AppStorage("username") private var username = ""
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("svae username", text: $username)
                .padding()
                .border(Color.gray)
            
            Toggle("dark mode parsistent", isOn: $isDarkMode)
            
            Text("save username \(username.isEmpty ? "none" : "username")")
                .padding()
                .background(isDarkMode ? .black : .white)
                .foregroundColor(isDarkMode ? .white : .black)
            
        }
    }
}

#Preview {
    Example29_AppStorage()
}
