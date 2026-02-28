//
//  Example14_Spacer.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/2/28.
//

import SwiftUI

struct Example14_Spacer: View {
    var body: some View {
        HStack {
            Text("Left Aligned")
            Spacer()
            Text("Right Aligned")
        }
        .padding()
        .background(Color.gray.opacity(0.1))
    }
}


