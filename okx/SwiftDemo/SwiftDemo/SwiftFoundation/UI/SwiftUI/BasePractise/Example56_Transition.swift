//
//  Example56_Transition.swift
//  SwiftDemo
//
//  Created by taojiang on 2026/3/3.
//

import SwiftUI

struct Example56_Transition: View {
    @State private var showView = false
    
    var body: some View {
        VStack(spacing: 20) {
            Button(showView ? "hide view" : "show view") {
                withAnimation {
                    showView.toggle()
                }
            }
            
            if showView {
                Text("animated view")
                    .font(.title)
                    .padding()
                    .background(.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
            }
            
        }
    }
}

#Preview {
    Example56_Transition()
}
