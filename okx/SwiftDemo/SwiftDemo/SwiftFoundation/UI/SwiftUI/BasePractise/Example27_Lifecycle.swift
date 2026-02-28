//
//  Example27_Lifecycle.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/2/28.
//

import SwiftUI

struct Example27_Lifecycle: View {
    @State private var data = ""
    
    var body: some View {
        Text(data)
            .font(.title)
            .onAppear{
                print("view appeared")
                loadData()
            }
            .onDisappear {
                print("view dispaaeared")
                clearUp()
            }
    }
    
    private func loadData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            data = "data loaded!"
        }
    }
    
    private func clearUp() {
        data = ""
    }
}

#Preview {
    Example27_Lifecycle()
}
