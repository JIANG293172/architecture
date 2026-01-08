//
//  ContentView.swift
//  SwiftUI04
//
//  Created by CQCA202121101_2 on 2025/11/3.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        UserView()
    }
}

struct User {
    var name: String
    var age: Int
    var isVerified: Bool
}

struct UserView: View {
    @State private var user = User(name: "李四", age: 25, isVerified: false)
    
    var body: some View {
        VStack {
            Text("姓名: \(user.name)")
            Text("年龄: \(user.age)")
            Toggle("已验证", isOn: $user.isVerified)
            
            Button("更新年龄") {
                user.age += 1  // 结构体是值类型，会触发视图更新
                user.name = "aa"
            }
        }
    }
}

#Preview {
    UserView()
}
