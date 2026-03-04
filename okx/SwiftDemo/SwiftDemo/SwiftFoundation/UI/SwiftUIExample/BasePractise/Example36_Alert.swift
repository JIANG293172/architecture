//
//  Example36_Alert.swift
//  SwiftDemo
//
//  Created by taojiang on 2026/2/28.
//

import SwiftUI

struct Example36_Alert: View {
    @State private var showAlert = false
    
    
    var body: some View {
        Button("show alert") {
            showAlert = true
        }
        .alert("alert title", isPresented: $showAlert) {
            Button("ok", role: .cancel) {
                
            }
            
            Button("delete", role: .destructive) {
                print("item deleted")
            }
        }  message: {
            Text("this is a destruction alert")
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

#Preview {
    Example36_Alert()
}
