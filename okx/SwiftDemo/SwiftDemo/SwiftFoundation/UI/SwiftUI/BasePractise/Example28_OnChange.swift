//
//  Example28_OnChange.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/2/28.
//

import SwiftUI

struct Example28_OnChange: View {
    @State private var username = ""
    @State private var isValid = false
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("enter username (min 5 chars)", text: $username)
                .padding()
                .border(isValid ? Color.green : .red)
            
            Text(isValid ? "valid username" : "username is too short")
                .foregroundColor(isValid ? .green : .red)
        }
        .onChange(of: username) { newValue in
            isValid = newValue.count >= 5
        }
            
    }
}

#Preview {
    Example28_OnChange()
}
