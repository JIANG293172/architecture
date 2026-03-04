//
//  Example46_ProgressView.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/3/3.
//

import SwiftUI

struct Example46_ProgressView: View {
    @State private var progress = 0.0
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 30) {
            ProgressView()
                .progressViewStyle(.circular)
                .scaleEffect(2)
                .opacity(isLoading ? 1 : 0)
            
            ProgressView(value: progress, total: 100)
                .progressViewStyle(.linear)
                .frame(height: 20)
            
            HStack(spacing: 20) {
                Button("start loading") {
                    isLoading = true
                    Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                        progress += 1
                        if progress >= 100 {
                            timer.invalidate()
                            isLoading  = false
                        }
                    }
                }
                
                Button("reset") {
                    progress = 0
                    isLoading = false
                }
            }
            
            
        }
        .padding()
    }
}

#Preview {
    Example46_ProgressView()
}
