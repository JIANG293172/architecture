//
//  Example37_Sheet.swift
//  SwiftDemo
//
//  Created by taojiang on 2026/2/28.
//

import SwiftUI

struct Example37_Sheet: View {
    @State private var showSheet = false
    
    var body: some View {
        Button("show sheet") {
            showSheet = true
        }
        .sheet(isPresented: $showSheet) {
            
            VStack(spacing: 20) {
                Text("modal sheet")
                    .font(.title)
                
                Button("dismiss") {
                    showSheet = false
                }
                .padding()
                .background(.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()
            .presentationDetents([.medium, .large])
        }
    }
}

#Preview {
    Example37_Sheet()
}
