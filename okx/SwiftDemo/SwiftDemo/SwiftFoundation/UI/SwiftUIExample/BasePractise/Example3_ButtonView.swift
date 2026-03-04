//
//  Example3_ButtonView.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/2/28.
//

import SwiftUI

struct Example3_ButtonView: View {
    @State private var isTapped = false
    
    var body: some View {
        Button {
            isTapped.toggle()
            print("Button tapped !")
        } label: {
            Text(isTapped ? "Tapped!" : "Tap Me")
                .padding()
                .background(isTapped ? Color.green : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
}

#Preview {
    Example3_ButtonView()
}
