//
//  Example44_ScrollViewReader.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/3/3.
//

import SwiftUI

struct Example44_ScrollViewReader: View {
    @State private var scrollToIndex = 0
    
    
    
    var body: some View {
        VStack {
            Button("Scroll to item 50") {
                scrollToIndex = 50
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            ScrollView {
                ScrollViewReader { proxy in
                    LazyVStack {
                        ForEach(0...100, id: \.self) { index in
                            Text("Item \(index)")
                                .frame(height: 50)
                                .background(.gray.opacity(0.1))
                                .cornerRadius(8)
                                .id(index)
                        }
                    }
                    .onChange(of: scrollToIndex) { oldValue, newValue in
                        
                        withAnimation {
                            proxy.scrollTo(newValue, anchor: .top)
                        }
                    }
                    
                }
            }
            
        }
        
    }
}

#Preview {
    Example44_ScrollViewReader()
}
