//
//  ContentView.swift
//  SwiftUI05
//
//  Created by CQCA202121101_2 on 2025/11/3.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            ParentView()
        }
        .padding()
    }
}

// 父视图
struct ParentView: View {
    @State private var isToggleOn = false
    @State private var text = ""
    @State private var volume: Double = 0.5
    
    var body: some View {
        VStack {
            Text("父视图状态")
            Text("开关: \(isToggleOn ? "开" : "关")")
            Text("文本: \(text)")
            Text("音量: \(volume, specifier: "%.2f")")
            
            Divider()
            
            // 传递绑定给子视图
            ChildToggleView(isOn: $isToggleOn)
            ChildTextField(text: $text)
            ChildSlider(value: $volume)
            
            // 多个绑定
            ChildMultipleBindings(toggle: $isToggleOn, text: $text, volume: $volume)
        }
        .padding()
    }
}

// 子视图 - 接收绑定
struct ChildToggleView: View {
    @Binding var isOn: Bool
    
    var body: some View {
        Toggle("子视图开关", isOn: $isOn)
            .padding()
    }
}

struct ChildTextField: View {
    @Binding var text: String
    
    var body: some View {
        TextField("输入文本...", text: $text)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
    }
}

struct ChildSlider: View {
    @Binding var value: Double
    
    var body: some View {
        VStack {
            Text("音量控制: \(value, specifier: "%.2f")")
            Slider(value: $value, in: 0...1)
        }
        .padding()
    }
}

// 接收多个绑定
struct ChildMultipleBindings: View {
    @Binding var toggle: Bool
    @Binding var text: String
    @Binding var volume: Double
    
    var body: some View {
        VStack {
            Toggle("多个绑定 - 开关", isOn: $toggle)
            TextField("多个绑定 - 文本", text: $text)
            Slider(value: $volume, in: 0...1)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
    }
}

#Preview {
    ContentView()
}
