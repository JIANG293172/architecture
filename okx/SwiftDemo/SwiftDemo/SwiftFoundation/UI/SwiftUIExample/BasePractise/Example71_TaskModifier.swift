//
//  Example71_TaskModifier.swift
//  SwiftDemo
//
//  Created by taojiang on 2026/3/3.
//

import SwiftUI

struct Example71_TaskModifier: View {
    @State var message = "loading ..."
        
    
    var body: some View {
        Text(message)
            .task {
                message = await featchData()
            }
    }
    
    private func featchData() async -> String {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return "data loaded"
    }
}

#Preview {
    Example71_TaskModifier()
}
