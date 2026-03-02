//
//  Example34_TaskModifier.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/2/28.
//

import SwiftUI

struct Example34_TaskModifier: View {
    @State private var data = "loading..."
    @State private var error: String?
    
    
    var body: some View {
        VStack(spacing: 20) {
            if let error = error {
                Text(error)
                    .foregroundColor(.red)
            } else {
                Text(data)
            }
        }
        .task {
            do {
                let result = try aw·ait fetchData()
                data = result
            } catch {
                self.error = "fail to load data :\(error.localizedDescription)"
            }
        }
        
    }
    
    private func fetchData() async throws -> String {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return "data fetched successfully !"
    }
}

#Preview {
    Example34_TaskModifier()
}
