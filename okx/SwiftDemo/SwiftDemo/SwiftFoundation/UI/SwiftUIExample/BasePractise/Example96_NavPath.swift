//
//  Example96_NavPath.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/3/4.
//

import SwiftUI

struct Example96_NavPath: View {
    @State var navPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navPath) {
            NavigationLink("go to detail", value: "detail")
                .navigationDestination(for: String.self) { val in
                    Text(val)
                }
        }
    }
}

#Preview {
    Example96_NavPath()
}
