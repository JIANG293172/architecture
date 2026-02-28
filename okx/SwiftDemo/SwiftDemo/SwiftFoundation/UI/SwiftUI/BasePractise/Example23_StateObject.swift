//
//  Example23_StateObject.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/2/28.
//

import SwiftUI
import Combine

class Example22_CounterModel: ObservableObject {
    @Published var count = 0
    
    func increment() {
        count += 1
    }
    
    func decrement() {
        count -= 1
    }
}

struct Example23_StateObject: View {
    @StateObject private var counter = Example22_CounterModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("count: \(counter.count)")
                .font(.title)
        }
        
        HStack(spacing: 20) {
            Button("-", action: counter.decrement)
                .font(.title)
                .frame(width: 50, height: 50)
            
            Button("+", action: counter.increment)
                .font(.title)
                .frame(width: 50, height: 50)
        }
    }
}



#Preview {
    Example23_StateObject()
}
