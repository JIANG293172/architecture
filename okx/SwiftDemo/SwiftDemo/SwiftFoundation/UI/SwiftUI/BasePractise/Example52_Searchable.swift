//
//  Example52_Searchable.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/3/3.
//

import SwiftUI

struct Example52_Searchable: View {
    let fruits = ["apple", "banana", "Orange", "Mango", "pineapple", "grapes", "strawberry"]
    @State private var searchText = ""
    
    var filteredFruits : [String] {
        if searchText.isEmpty {
            return fruits
        } else {
            return fruits.filter { fruit in
                fruit.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        
        NavigationStack {
            List(filteredFruits, id: \.self) { fruit in
                Text(fruit)
            }
            .navigationTitle("fruits")
            .searchable(text: $searchText) {
                ForEach(["apple", "banana", "orange"].filter{$0.localizedStandardContains(searchText)}, id: \.self) { suggestion in
                    Text("search for \(suggestion)")
                        .searchCompletion(suggestion)
                }
            }
            .autocorrectionDisabled()
        }
        
    }
}

#Preview {
    Example52_Searchable()
}
