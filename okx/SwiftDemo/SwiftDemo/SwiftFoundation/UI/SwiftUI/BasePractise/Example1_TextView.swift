//
//  Example1_TextView.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/2/28.
//

import SwiftUI

struct Example1_TextView: View {
    var body: some View {
        Text("Hello, SwiftUI!")
            .font(.title)
            .foregroundColor(.blue)
            .bold()
            .padding()
    }
}

#Preview {
    Example1_TextView()
}
