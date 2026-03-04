//
//  Example63_ViewComposition.swift
//  SwiftDemo
//
//  Created by taojiang on 2026/3/3.
//

import SwiftUI

struct Example63_ViewComposition: View {
    var body: some View {
        VStack(spacing: 16) {
            CardHeader(title: "home dashboard")
            CardRow(icon: "house", text: "home")
            CardRow(icon: "gear", text: "setting")
        }
        .padding()
    }
}

struct CardHeader: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.largeTitle.bold())
    }
}

struct CardRow: View {
    let icon: String
    let text: String
    var body: some View {
        HStack {
            Image(systemName: icon)
            Text(text)
            Spacer()
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
    }
}

#Preview {
    Example63_ViewComposition()
}
