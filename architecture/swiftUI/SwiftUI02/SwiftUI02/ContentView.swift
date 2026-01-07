//
//  ContentView.swift
//  SwiftUI02
//
//  Created by CQCA202121101_2 on 2025/11/3.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

// 数据模型
class UserProfile: ObservableObject {
    @Published var name: String = ""
    @Published var age: Int = 0
    @Published var isVerified: Bool = false
    
    func updateProfile() {
        // 数据更新会自动通知视图
        objectWillChange.send()
    }
}

// 使用 ObservedObject 的视图
struct ProfileView: View {
    @ObservedObject var profile: UserProfile
    
    var body: some View {
        VStack {
            TextField("姓名", text: $profile.name)
            Stepper("年龄: \(profile.age)", value: $profile.age)
            Toggle("已验证", isOn: $profile.isVerified)
            
            Button("更新资料") {
                profile.updateProfile()
            }
        }
        .padding()
    }
}

// 在父视图中使用
struct ParentView: View {
    @StateObject private var profile = UserProfile() // 创建实例
    
    var body: some View {
        ProfileView(profile: profile) // 传递给子视图
    }
}

#Preview {
    ParentView()
}
