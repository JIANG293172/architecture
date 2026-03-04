//
//  Example77_Popover.swift
//  SwiftDemo
//
//  Created by taojiang on 2026/3/3.
//

import SwiftUI

struct Example77_Popover: View {
    @State var showPopover = false
    
    var body: some View {
        Button("popove") {
            showPopover = true
        }
        .popover(isPresented: $showPopover) {
            Text("popover content")
                .padding()
        }
    }
}

#Preview {
    Example77_Popover()
}
