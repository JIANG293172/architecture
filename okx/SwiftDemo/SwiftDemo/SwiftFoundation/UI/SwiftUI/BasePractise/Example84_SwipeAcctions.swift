//
//  Example84_SwipeAcctions.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/3/4.
//

import SwiftUI

struct Example84_SwipeAcctions: View {
    var body: some View {
        List {
            Text("swipe me")
                .swipeActions {
                    Button("delete", role: .destructive) {}
                }
            
        }
    }
}

#Preview {
    Example84_SwipeAcctions()
}
