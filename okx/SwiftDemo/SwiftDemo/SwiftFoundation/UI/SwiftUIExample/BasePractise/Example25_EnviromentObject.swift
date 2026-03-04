//
//  Example25_EnviromentObject.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/2/28.
//

import SwiftUI

struct Example25_EnviromentObject: View {
    var body: some View {
        Example25_ParentView().environmentObject(Example22_CounterModel())
    }
}


struct Example25_ParentView: View {
    var body: some View {
        VStack {
            Text("parnet view")
            
            Example25_ChildView()
        }
    }
    
}

struct Example25_ChildView: View {
    @EnvironmentObject var counter: Example22_CounterModel
    
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Count \(counter.count)")
            
            Button("increment", action: counter.increment)
                .padding()
                .background(Color.purple)
                .foregroundColor(.white)
                .cornerRadius(8)
            
        }
    }
}



#Preview {
    Example25_EnviromentObject()
}
