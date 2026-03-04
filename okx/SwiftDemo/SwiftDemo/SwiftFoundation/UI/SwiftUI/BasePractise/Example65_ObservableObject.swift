//
//  Example65_ObservableObject.swift
//  SwiftDemo
//
//  Created by taojiang on 2026/3/3.
//

import SwiftUI
import Combine

class Example65_DataModel: ObservableObject {
    @Published var count = 0
}

struct Example65_ObservableObject: View {
    @StateObject var model = Example65_DataModel()
    
    var body: some View {
        VStack {
            Text("count: \(model.count)")
            ChildObservedView(model: model)
        }
    }
}


struct ChildObservedView: View {
    @ObservedObject var model: Example65_DataModel
    
    var body: some View {
        Button("increase") {
            model.count += 1
        }
    }
}

#Preview {
    Example65_ObservableObject()
}
