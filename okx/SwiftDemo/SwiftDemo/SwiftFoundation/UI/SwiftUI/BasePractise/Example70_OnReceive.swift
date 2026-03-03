//
//  Example70_OnReceive.swift
//  SwiftDemo
//
//  Created by taojiang on 2026/3/3.
//

import SwiftUI
import Combine

struct Example70_OnReceive: View {
    @State var currentTime = Date()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Text("\(currentTime)")
            .onReceive(timer) { time in
                currentTime = time
            }
    }
}

#Preview {
    Example70_OnReceive()
}
