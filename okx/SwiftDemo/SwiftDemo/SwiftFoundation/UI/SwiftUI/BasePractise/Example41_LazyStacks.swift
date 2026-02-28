//
//  Example41_LazyStacks.swift
//  SwiftDemo
//
//  Created by taojiang on 2026/2/28.
//

import SwiftUI

struct Example41_LazyStacks: View {
    
    var body: some View {
        ScrollView {
            // 视图之外不会创建，出去就销毁
            //  Lazy stacks for large lists to improve performance
            LazyVStack(spacing: 10) {
                
                ForEach(1...1000, id: \.self) { number in
                    Text("item \(number)")
                        .frame(height: 50)
                        .background(.gray.opacity(0.1))
                        .cornerRadius(8)
        
                }
            }
            
            
        }
    }
}

#Preview {
    Example41_LazyStacks()
}
