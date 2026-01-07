//
//  ContentView.swift
//  SwiftUI03
//
//  Created by CQCA202121101_2 on 2025/11/3.
//

import SwiftUI


// 数据模型
class UserSettings: ObservableObject {
    @Published var username: String = ""
}

// 在根视图注入
struct MyApp: App {
    @StateObject private var settings = UserSettings()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settings) // 注入到环境
        }
    }
}

// 在子视图中使用
struct ContentView: View {
    @EnvironmentObject var settings: UserSettings // 从环境中获取

    var body: some View {
        VStack {
            Text("Username: \(settings.username)")
            Button("Change") {
                settings.username = "John"
            }
        }
    }
}


#Preview {
    ContentView()
}
