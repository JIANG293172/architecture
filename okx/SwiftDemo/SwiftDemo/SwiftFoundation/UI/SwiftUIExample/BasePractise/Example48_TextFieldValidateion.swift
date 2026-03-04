//
//  Example48_TextFieldValidateion.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/3/3.
//

import SwiftUI

struct Example48_TextFieldValidateion: View {
    @State private var email = ""
    @State private var password = ""
    @State private var emailError = ""
    @State private var passwordError = ""
    
    
    var body: some View {
        Form {
            Section("email") {
                
                TextField("enter email" ,text: $email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .onChange(of: email) { oldValue, newValue in
                        validateEmail(email: newValue)
                    }
                
                if !emailError.isEmpty {
                    Text(emailError)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            
            Section("password") {
                SecureField("enter password", text: $password)
                    .onChange(of: password) { oldValue, newValue in
                        validatePassword(password: newValue)
                    }
            }
            
            Section {
                Button("submit") {
                    validateForm()
                }
                .disabled(!isFormValid)
            }
        }
        
    }
    
    
    private func validateEmail(email: String) {
        if email.isEmpty {
            emailError = ""
        } else if !email.contains("@") || !email.contains(".") {
            emailError = "please enter a valid email"
        } else {
            emailError = ""
        }
        
    }
    
    private func validatePassword(password: String) {
        if password.isEmpty {
            passwordError = ""
        } else if password.count < 8 {
            passwordError = "password must be at least 8 characters"
        } else {
            passwordError = ""
        }
    }
    
    private var isFormValid: Bool {
        emailError.isEmpty && passwordError.isEmpty && !email.isEmpty && !password.isEmpty
    }
    
    private func validateForm() {
        validateEmail(email: email)
        validatePassword(password: password)
        
        if isFormValid {
            print("form submiited successfully")
        }
    }
    
}

#Preview {
    Example48_TextFieldValidateion()
}
