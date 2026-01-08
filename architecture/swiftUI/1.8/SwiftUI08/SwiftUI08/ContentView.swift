//
//  ContentView.swift
//  SwiftUI08
//
//  Created by CQCA202121101_2 on 2025/11/3.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private var cancellable: AnyCancellable?

    var body: some View {
        VStack {
            Button("获取数据") {
                cancellable = featchData()
                .sink(receiveCompletion: { complate in
                    print(complate)
                }, receiveValue: { data in
                    print(data)
                })
        }
        }
        .padding()
    }
}

func featchData() -> Future<String, Error> {
    Future { promise in
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
//            promise(.success("token"))
            let error = URLError(.cannotConnectToHost)
                promise(.failure(error)) // 传递错误
        }
          
        
        // 2. 用 Combine 串联请求（无嵌套）
        let cancellable = login()
            .flatMap { token in fetchUserInfo(token: token) } // 登录后→获取用户信息
            .flatMap { userId in fetchOrders(userId: userId) } // 获取用户信息后→获取订单
            .receive(on: DispatchQueue.main) // 切换到主线程
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("错误：\(error)")
                    }
                },
                receiveValue: { orders in
                    print("最终订单：\(orders)") // 输出：["订单1", "订单2"]
                }
            )
        
        
        // 2. 用 Task + await 串联请求（无嵌套，类似同步代码）
        let task = Task {
            do {
                let token = try await login() // 等待登录完成
                let userId = try await fetchUserInfo(token: token) // 等待用户信息
                let orders = try await fetchOrders(userId: userId) // 等待订单
                print("最终订单：\(orders)") // 输出：["订单1", "订单2"]
            } catch {
                print("错误：\(error)")
            }
        }

        
        
        
    }
    
}



// 1. 定义三个网络请求（返回 Future 发布者）
func login() -> Future<String, Error> {
    Future { promise in
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            promise(.success("token_123")) // 模拟登录成功，返回 token
        }
    }
}

func fetchUserInfo(token: String) -> Future<Int, Error> {
    Future { promise in
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            promise(.success(1001)) // 模拟返回用户 ID
        }
    }
}

func fetchOrders(userId: Int) -> Future<[String], Error> {
    Future { promise in
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            promise(.success(["订单1", "订单2"])) // 模拟返回订单
        }
    }
}

// 1. 定义三个异步函数（用 async throws）
func login() async throws -> String {
    try await Task.sleep(nanoseconds: 1_000_000_000) // 模拟耗时
    return "token_123" // 模拟返回 token
}

func fetchUserInfo(token: String) async throws -> Int {
    try await Task.sleep(nanoseconds: 1_000_000_000)
    return 1001 // 模拟返回用户 ID
}

func fetchOrders(userId: Int) async throws -> [String] {
    try await Task.sleep(nanoseconds: 1_000_000_000)
    return ["订单1", "订单2"]
}




#Preview {
    ContentView()
}
