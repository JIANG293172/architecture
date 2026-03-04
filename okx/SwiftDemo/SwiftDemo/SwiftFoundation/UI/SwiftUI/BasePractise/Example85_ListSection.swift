//
//  Example85_ListSection.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/3/4.
//

import SwiftUI

struct Example85_ListSection: View {
    var body: some View {
        List {
            
            Section("section 1") {
                Text("a")
                Text("b")
            }
            
            Section("section 2") {
                Text("c")
            }
        }
    }
}

#Preview {
    Example85_ListSection()
}
