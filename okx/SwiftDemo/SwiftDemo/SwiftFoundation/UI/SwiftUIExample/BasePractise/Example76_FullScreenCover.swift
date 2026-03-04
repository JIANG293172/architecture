//
//  Example76_FullScreenCover.swift
//  SwiftDemo
//
//  Created by taojiang on 2026/3/3.
//

import SwiftUI

struct Example76_FullScreenCover: View {
    @State var showFull = false
    
    var body: some View {
        Button("full screen") {
            showFull = true
        }
        .fullScreenCover(isPresented: $showFull) {
            Text("full screen view")
        }
    }
}

#Preview {
    Example76_FullScreenCover()
}
