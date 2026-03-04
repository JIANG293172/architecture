//
//  Example12_TableView.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/2/28.
//

import SwiftUI

struct Example12_TableView: View {
    var body: some View {
        
        TabView {
            Text("Home Screen")
                .tabItem {
                    Image(systemName: "house")
                    Text("home")
                }.tag(0)
    
            Text("Profile Screen")
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
                .tag(1)
            
            Text("Settings screen")
                .tabItem {
                    Image(systemName: "gear")
                        Text("Setting")
                }.tag(2)
            
            
        }
        
    }
}

#Preview {
    Example12_TableView()
}
