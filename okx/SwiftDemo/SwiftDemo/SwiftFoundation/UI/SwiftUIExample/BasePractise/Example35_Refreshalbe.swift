//
//  Example35_Refreshalbe.swift
//  SwiftDemo
//
//  Created by taojiang on 2026/2/28.
//

import SwiftUI

struct Example35_Refreshalbe: View {
    @State private var items = ["Item1", "item2", "item3"]
    
    var body: some View {
        
        List(items, id: \.self) { item in
            Text(item)
        }
        .refreshable {
            await loadNewData()
        }
        
    }
    
    private func loadNewData() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        items = ["refreshed item1", "refreshed item2", "refresed item3", "new item 4"]
        
    }
}

#Preview {
    Example35_Refreshalbe()
}
