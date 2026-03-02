//
//  Example38_ConfirmationDialog.swift
//  SwiftDemo
//
//  Created by taojiang on 2026/2/28.
//

import SwiftUI

struct Example38_ConfirmationDialog: View {
    @State private var showDiglog = false
    
    var body: some View {
        Button("delete item") {
            showDiglog = true
        }
        .confirmationDialog("are you sure", isPresented: $showDiglog) {
            Button("delete", role: .destructive) {
                print("item deleted")
            }
            
            Button("cancel", role: .cancel) {}
            
            Button("archive") {
                print("item archived")
            }
        } message: {
            Text("this action cannot be undone")
        }
        
        Spacer()
    }
}

#Preview {
    Example38_ConfirmationDialog()
}
