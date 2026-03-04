//
//  Example30_Combine.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/2/28.
//

import SwiftUI
import Combine

class Example30_SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var debouncedText = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $searchText.debounce(for: .seconds(2), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] value in
                self?.debouncedText = value
                print("seach for \(value)")
            }
            .store(in: &cancellables)
    }
}

struct Example30_Combine: View {
    @StateObject private var viewModel = Example30_SearchViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("search (debounced)", text: $viewModel.searchText)
                .padding()
                .border(Color.gray)
            
            Text("debounced text: \(viewModel.debouncedText)")
        }
    }
}

