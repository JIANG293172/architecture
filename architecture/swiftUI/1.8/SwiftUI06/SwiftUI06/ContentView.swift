//
//  ContentView.swift
//  SwiftUI06
//
//  Created by CQCA202121101_2 on 2025/11/3.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            ComprehensiveExample()
        }
        .padding()
    }
}

// 综合数据模型
class AppData: ObservableObject {
    @Published var users: [String] = ["张三", "李四", "王五"]
    @Published var selectedUserIndex = 0
    @Published var themeColor: String = "blue"
    
    var selectedUser: String {
        guard users.indices.contains(selectedUserIndex) else { return "" }
        return users[selectedUserIndex]
    }
}

// 设置模型
class Settings: ObservableObject {
    @Published var notificationsEnabled = true
    @Published var darkMode = false
    @Published var fontSize: Double = 16
}

// 主应用
struct ComprehensiveExample: View {
    @StateObject private var appData = AppData()
    @StateObject private var settings = Settings()
    
    var body: some View {
        TabView {
            UserView(appData: appData)
                .tabItem { Label("用户", systemImage: "person") }
            
            SettingsView(settings: settings)
                .tabItem { Label("设置", systemImage: "gear") }
            
            CombinedView(appData: appData, settings: settings)
                .tabItem { Label("综合", systemImage: "square.grid.2x2") }
        }
        .environmentObject(appData)  // 注入到环境
    }
}

// 用户视图
struct UserView: View {
    @ObservedObject var appData: AppData
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("选择用户", selection: $appData.selectedUserIndex) {
                    ForEach(0..<appData.users.count, id: \.self) { index in
                        Text(appData.users[index]).tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Text("当前用户: \(appData.selectedUser)")
                    .font(.title)
                
                // 使用 @State 管理本地临时状态
                UserDetailView(selectedUser: appData.selectedUser)
            }
            .navigationTitle("用户管理")
        }
    }
}

// 用户详情视图 - 使用 @State 和 @Binding
struct UserDetailView: View {
    let selectedUser: String
    @State private var temporaryNote = ""
    
    var body: some View {
        VStack {
            Text("用户: \(selectedUser)")
                .font(.headline)
            
            TextField("添加备注...", text: $temporaryNote)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Text("临时备注: \(temporaryNote)")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding()
    }
}

// 设置视图
struct SettingsView: View {
    @ObservedObject var settings: Settings
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("偏好设置")) {
                    Toggle("通知", isOn: $settings.notificationsEnabled)
                    Toggle("深色模式", isOn: $settings.darkMode)
                    
                    VStack {
                        Text("字体大小: \(settings.fontSize, specifier: "%.0f")")
                        Slider(value: $settings.fontSize, in: 12...24, step: 1)
                    }
                }
            }
            .navigationTitle("设置")
        }
    }
}

// 综合视图 - 使用环境对象
struct CombinedView: View {
    @ObservedObject var appData: AppData
    @ObservedObject var settings: Settings
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            VStack {
                Text("综合信息")
                    .font(.system(size: CGFloat(settings.fontSize)))
                    .foregroundColor(settings.darkMode ? .white : .black)
                
                List {
                    ForEach(appData.users, id: \.self) { user in
                        Text(user)
                    }
                }
                
                Text("通知: \(settings.notificationsEnabled ? "开启" : "关闭")")
                Text("当前主题: \(colorScheme == .dark ? "深色" : "浅色")")
            }
            .navigationTitle("综合视图")
            .background(settings.darkMode ? Color.black : Color.white)
        }
    }
}



#Preview {
    ContentView()
}
