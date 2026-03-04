//
//  Example32_MultiplePublished.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/2/28.
//

import SwiftUI
import Combine


class Example32_ForModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isFormValid = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        Publishers.CombineLatest($email, $password)
            .map { email, password in
                email.contains("@") && password.count >= 8
            }
            .assign(to: \.isFormValid, on: self)
            .store(in: &cancellables)
    }
    
}



struct Example32_MultiplePublished: View {
    @StateObject private var formModel = Example32_ForModel()
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("email", text: $formModel.email)
                .padding()
                .border(.gray)
        
            SecureField("password", text: $formModel.password)
            
            Button("submit") {
                print("form submitted")
            }
            .padding()
            .background(formModel.isFormValid ? .blue : .gray)
            .foregroundColor(.white)
            .cornerRadius(8)
            .disabled(!formModel.isFormValid)
        }
    }
}

#Preview {
    Example32_MultiplePublished()
}
