//
//  Example68_SceneStorage.swift
//  SwiftDemo
//
//  Created by taojiang on 2026/3/3.
//

import SwiftUI

struct Example68_SceneStorage: View {
    @SceneStorage("selected_tab") var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Text("tab1").tag(0)
            Text("tab2").tag(1)
        }
    }
}

#Preview {
    Example68_SceneStorage()
}
