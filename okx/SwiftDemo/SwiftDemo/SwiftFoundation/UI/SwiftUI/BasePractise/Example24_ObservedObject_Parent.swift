//
//  Example24_ObservedObject_Parent.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/2/28.
//

import SwiftUI

struct Example24_ObservedObject_Parent: View {
    @StateObject private var counter = Example22_CounterModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("parent count: \(counter.count)")
            Example24_ChildObserverView(counter: counter)
        }
    }
}

struct Example24_ChildObserverView: View {
    @ObservedObject var counter: Example22_CounterModel
    
    var body: some View {
        VStack(spacing: 10) {
            Text("child count: \(counter.count)")
            Button("incremetn from child", action: counter.increment)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
}

#Preview {
    Example24_ObservedObject_Parent()
}
