//
//  SwiftUI09App.swift
//  SwiftUI09
//
//  Created by CQCA202121101_2 on 2025/11/5.
//

import SwiftUI

@main
struct SwiftUI09App: App {
    init() {
        // 设置 TabBar 未选中图标/文字颜色
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color(hex: "999999"))
        // 设置 TabBar 背景色
        UITabBar.appearance().backgroundColor = .white
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
