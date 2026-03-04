//
//  Example33_FocusState.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/2/28.
//

import SwiftUI

struct Example33_FocusState: View {
    @State private var email = ""
    @State private var password = ""
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case email, password
    }
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("email", text: $email)
                .padding()
                .border(.gray)
                .focused($focusedField, equals: .email)
                .submitLabel(.next)
                .onSubmit {
                    focusedField = .password
                }
            
            SecureField("password", text: $password)
                .padding()
                .border(.gray)
                .focused($focusedField, equals: .password)
                .submitLabel(.done)
                .onSubmit {
                    focusedField = nil
                }
            Button("dismiss keyboard") {
                print(focusedField)
                focusedField = nil
            }
        }
        
        
        
    }
}

#Preview {
    Example33_FocusState()
}
