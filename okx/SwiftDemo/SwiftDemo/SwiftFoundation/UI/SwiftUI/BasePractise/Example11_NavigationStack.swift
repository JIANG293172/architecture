//
//  Example11_NavigationStack.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/2/28.
//

import SwiftUI

struct Example11_NavigationStack: View {
    
    var body: some View {
        NavigationStack {
            List(1...5, id:\.self) { number in
                NavigationLink("go to detail \(number)") {
                    Example11DetailView(number: number)
                }
            }
            
            NavigationLink("go to detail \(2)") {
                Example11DetailView(number: 2)
            }
            NavigationLink("go to detail \(3)") {
                Example11DetailView(number: 3)
            }
        }
    }
    
}


struct Example11DetailView: View {
    let number: Int
    var body: some View {
        Text("Detail Screen \(number)")
    }
}

enum Example11_NavPath: Hashable {
    case settings
    case detail
}

struct Example11_HomeView: View {
    // navPath 对应 UIKit 的 viewControllers 数组
    @State private var navPath: [Example11_NavPath] = []
    
    var body: some View {
        NavigationStack(path: $navPath) {
            VStack {
                // 对应 pushViewController
                Button("跳转到设置") {
                    navPath.append(.settings)
                }
                
                // 对应 popViewController
                Button("返回上一页") {
                    navPath.removeLast()
                }
                
                // 对应 popToRootViewController
                Button("返回首页") {
                    navPath.removeAll()
                }
                
                // 对应 setViewControllers
                Button("替换栈顶") {
                    navPath[navPath.endIndex-1] = .detail
                }
            }
            .navigationDestination(for: Example11_NavPath.self) { path in
                switch path {
                case .settings: Example11_NavigationStack()
                case .detail: Example11_NavigationStack()
                }
            }
        }
    }
}
