//
//  Example4_TextFieldView.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/2/28.
//

import SwiftUI

struct Example4_TextFieldView: View {
    @State private var username = ""
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Enter Username", text: $username)
                .padding()
                .border(Color.gray, width: 1)
                .cornerRadius(8)
                .padding(.horizontal)
                .onChange(of: username) { oldValue, newValue in
                    print("newValue: \(newValue)")
                }
            
            Text("you  entered: \(username)")
                .font(.subheadline)
        }
    }
}

#Preview {
    Example4_TextFieldView()
}
