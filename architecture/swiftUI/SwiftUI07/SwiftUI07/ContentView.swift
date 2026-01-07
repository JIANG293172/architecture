//
//  ContentView.swift
//  SwiftUI07
//
//  Created by CQCA202121101_2 on 2025/11/3.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Button("点击") {
                Task {
                    await testTaskThreads()
                }
                
            }
        }
        .padding()
    }
}

func testTaskThreads() async -> String  {
    
    print("主线程: \(Thread.current)")
    
    Task {
        print("当前线程: \(Thread.current)")
        // 这不会自动创建新线程，而是在系统的线程池中执行
    }
    
    for i in 0..<10 {
        Task {
            print("任务 \(i) 在线程: \(Thread.current)")
            // 模拟一些工作
            try? await Task.sleep(nanoseconds: 100_000_000)
        }
    }
    
    return "aa"
}

// 调用测试


#Preview {
    ContentView()
}
