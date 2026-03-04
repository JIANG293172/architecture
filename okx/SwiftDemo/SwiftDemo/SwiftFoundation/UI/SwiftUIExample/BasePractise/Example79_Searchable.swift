//
//  Example79_Searchable.swift
//  SwiftDemo
//
//  Created by taojiang on 2026/3/3.
//

import SwiftUI

struct Example79_Searchable: View {
    @State var search = ""
    let list = ["apple", "banana", "orange"]
    
    var body: some View {
        NavigationStack {
            List(list.filter{search.isEmpty || $0.contains(search)}, id:\.self) {
                Text($0)
            }
            .searchable(text: $search)
        }
    }
}

#Preview {
    Example79_Searchable()
}
