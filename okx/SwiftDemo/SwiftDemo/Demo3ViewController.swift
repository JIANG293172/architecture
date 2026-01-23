//
//  Demo3ViewController.swift
//  SwiftUI10
//
//  Created by CQCA202121101_2 on 2026/1/22.
//

import UIKit
import Foundation

// Demo 3 ViewController
class Demo3ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Demo 3: 多线程示例"
        view.backgroundColor = .white
        
        let label = UILabel()
        label.text = "多线程示例 - 查看控制台输出"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // 运行所有多线程示例
        runAllExamples()
    }
    
    private func runAllExamples() {
        print("=== 开始运行多线程示例 ===")
        
        // 1. GCD 核心机制示例
        runGCDExamples()
        
        // 2. 多读单写 Dictionary 示例
        runReadWriteDictionaryExample()
        
        // 3. Token 刷新逻辑示例
        runTokenRefreshExample()
        
        // 4. Swift 5.5 新并发模型示例
        runSwiftConcurrencyExamples()
        
        print("=== 多线程示例运行完成 ===")
    }
    
    // MARK: - 一、GCD 核心机制示例
    private func runGCDExamples() {
        print("\n=== GCD 核心机制示例 ===")
        
        // 1. 队列创建
        let serialQueue = DispatchQueue(label: "com.okx.serial")
        let concurrentQueue = DispatchQueue(label: "com.okx.concurrent", attributes: .concurrent)
        let globalQueue = DispatchQueue.global(qos: .userInitiated)
        
        print("1. 队列创建完成")
        
        // 2. 任务调度
        print("2. 开始任务调度示例")
        
        // 异步执行
        concurrentQueue.async {
            print("   异步任务1执行中...")
            Thread.sleep(forTimeInterval: 1)
            print("   异步任务1完成")
        }
        
        // 同步执行
        serialQueue.sync {
            print("   同步任务1执行中...")
            Thread.sleep(forTimeInterval: 0.5)
            print("   同步任务1完成")
        }
        
        // 3. 线程安全：屏障
        print("3. 开始屏障示例")
        var sharedResource = 0
        
        // 并发读
        for i in 1...3 {
            concurrentQueue.async {
                print("   读操作\(i): sharedResource = \(sharedResource)")
                Thread.sleep(forTimeInterval: 0.1)
            }
        }
        
        // 屏障写
        concurrentQueue.async(flags: .barrier) {
            print("   屏障写操作开始")
            sharedResource = 42
            print("   屏障写操作完成: sharedResource = \(sharedResource)")
            Thread.sleep(forTimeInterval: 0.5)
        }
        
        // 再次并发读
        for i in 4...6 {
            concurrentQueue.async {
                print("   读操作\(i): sharedResource = \(sharedResource)")
                Thread.sleep(forTimeInterval: 0.1)
            }
        }
        
        // 4. 任务组
        print("4. 开始任务组示例")
        let group = DispatchGroup()
        
        globalQueue.async(group: group) {
            print("   任务A执行中...")
            Thread.sleep(forTimeInterval: 1)
            print("   任务A完成")
        }
        
        globalQueue.async(group: group) {
            print("   任务B执行中...")
            Thread.sleep(forTimeInterval: 0.5)
            print("   任务B完成")
        }
        
        // 异步等待
        group.notify(queue: .main) {
            print("   所有任务完成，更新UI")
        }
        
        // 5. 手动取消
        print("5. 开始手动取消示例")
        var isCancelled = false
        
        globalQueue.async {
            var counter = 0
            while !isCancelled && counter < 5 {
                print("   任务运行中... 计数: \(counter)")
                Thread.sleep(forTimeInterval: 0.3)
                counter += 1
            }
            print("   任务结束")
        }
        
        // 延迟取消
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            print("   取消任务")
            isCancelled = true
        }
    }
    
    // MARK: - 二、多读单写 Dictionary 设计
    private func runReadWriteDictionaryExample() {
        print("\n=== 多读单写 Dictionary 示例 ===")
        
        let safeDictionary = ReadWriteDictionary<String, Int>()
        
        // 并发读操作
        for i in 1...5 {
            DispatchQueue.global().async {
                let value: Int? = safeDictionary.read(key: "key\(i % 3)")
                print("   读操作\(i): key\(i % 3) = \(value ?? -1)")
            }
        }
        
        // 写操作
        DispatchQueue.global().async {
            safeDictionary.write(key: "key1", value: 100)
            print("   写操作: key1 = 100")
        }
        
        DispatchQueue.global().async {
            safeDictionary.write(key: "key2", value: 200)
            print("   写操作: key2 = 200")
        }
        
        // 再次并发读
        for i in 6...10 {
            DispatchQueue.global().async {
                let value = safeDictionary.read(key: "key\(i % 3)")
                print("   读操作\(i): key\(i % 3) = \(value ?? -1)")
            }
        }
    }
    
    // 多读单写 Dictionary 实现
    class ReadWriteDictionary<Key: Hashable, Value> {
        private var dictionary: [Key: Value] = [:]
        private let queue = DispatchQueue(label: "com.okx.readwrite", attributes: .concurrent)
        
        func read(key: Key) -> Value? {
            var value: Value?
            queue.sync {
                value = dictionary[key]
            }
            return value
        }
        
        func write(key: Key, value: Value) {
            queue.async(flags: .barrier) {
                self.dictionary[key] = value
            }
        }
        
        func remove(key: Key) {
            queue.async(flags: .barrier) {
                self.dictionary.removeValue(forKey: key)
            }
        }
        
        var count: Int {
            var count = 0
            queue.sync {
                count = dictionary.count
            }
            return count
        }
    }
    
    // MARK: - 三、Token 刷新逻辑示例
    private func runTokenRefreshExample() {
        print("\n=== Token 刷新逻辑示例 ===")
        
        let tokenManager = TokenManager()
        
        // 模拟多个网络请求同时触发
        for i in 1...5 {
            DispatchQueue.global().async {
                print("   网络请求\(i)开始，需要验证token")
                tokenManager.refreshTokenIfNeeded {success in
                    print("   网络请求\(i)token验证结果: \(success)")
                }
            }
        }
    }
    
    // Token 管理器实现
    class TokenManager {
        private var isRefreshing = false
        private var refreshCompletions: [(Bool) -> Void] = []
        private let queue = DispatchQueue(label: "com.okx.token", attributes: .concurrent)
        private let refreshSemaphore = DispatchSemaphore(value: 1)
        
        func refreshTokenIfNeeded(completion: @escaping (Bool) -> Void) {
            queue.async {
                // 检查是否正在刷新
                let shouldRefresh = self.queue.sync {
                    if self.isRefreshing {
                        // 已经有刷新任务，加入回调队列
                        self.refreshCompletions.append(completion)
                        return false
                    } else {
                        // 开始刷新
                        self.isRefreshing = true
                        self.refreshCompletions.append(completion)
                        return true
                    }
                }
                
                if shouldRefresh {
                    print("   开始刷新token...")
                    
                    // 模拟网络请求刷新token
                    DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                        // 模拟刷新结果
                        let success = Bool.random()
                        print("   token刷新结果: \(success)")
                        
                        // 通知所有等待的请求
                        self.queue.async(flags: .barrier) {
                            let completions = self.refreshCompletions
                            self.refreshCompletions.removeAll()
                            self.isRefreshing = false
                            
                            // 调用所有回调
                            for completion in completions {
                                DispatchQueue.main.async {
                                    completion(success)
                                }
                            }
                        }
                    }
                } else {
                    print("   已有token刷新任务，等待结果...")
                }
            }
        }
    }
    
    // MARK: - 四、Swift 5.5 新并发模型示例
    private func runSwiftConcurrencyExamples() {
        print("\n=== Swift 5.5 新并发模型示例 ===")
        
        // 启动异步任务
        Task {
            await runAsyncAwaitExample()
            await runTaskGroupExample()
            await runActorExample()
        }
    }
    
    // 1. async/await 示例
    private func runAsyncAwaitExample() async {
        print("1. 开始 async/await 示例")
        
        do {
            let price: Double = try await fetchOKXPriceAsync(symbol: "BTC-USDT")
            print("   BTC-USDT 价格: \(price)")
        } catch {
            print("   获取价格失败: \(error)")
        }
    }
    
    // 模拟网络请求
    private func fetchOKXPriceAsync(symbol: String) async throws -> Double {
        // 模拟网络延迟
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        // 模拟返回价格
        let mockPrice = Double.random(in: 30000...60000)
        return mockPrice
    }
    
    // 2. Task Group 示例
    private func runTaskGroupExample() async {
        print("\n2. 开始 Task Group 示例")
        
        do {
            let prices = try await fetchMultiPricesAsync(symbols: ["BTC-USDT", "ETH-USDT", "USDT-USD"])
            print("   多币种价格: \(prices)")
        } catch {
            print("   获取多币种价格失败: \(error)")
        }
    }
    
    private func fetchMultiPricesAsync(symbols: [String]) async throws -> [String: Double] {
        var prices: [String: Double] = [:]
        
        try await withThrowingTaskGroup(of: (String, Double).self) { group in
            for symbol in symbols {
                group.addTask {
                    let price = try await self.fetchOKXPriceAsync(symbol: symbol)
                    return (symbol, price)
                }
            }
            
            for try await (symbol, price) in group {
                prices[symbol] = price
            }
        }
        
        return prices
    }
    
    // 3. Actor 示例
    private func runActorExample() async {
        print("\n3. 开始 Actor 示例")
        
        let account = BankAccount(initialBalance: 1000)
        
        // 并发操作
        await withTaskGroup(of: Void.self) { group in
            // 存款操作
            for i in 1...3 {
                group.addTask {
                    await account.deposit(amount: Double(i * 100))
                    print("   存款操作\(i)完成")
                }
            }
            
            // 取款操作
            for i in 1...2 {
                group.addTask {
                    let success = await account.withdraw(amount: Double(i * 150))
                    print("   取款操作\(i)结果: \(success)")
                }
            }
        }
        
        let balance = await account.getBalance()
        print("   最终账户余额: \(balance)")
    }
    
    // Actor 实现线程安全
    actor BankAccount {
        private var balance: Double
        
        init(initialBalance: Double) {
            self.balance = initialBalance
        }
        
        func deposit(amount: Double) {
            balance += amount
            print("   存款: +\(amount), 余额: \(balance)")
        }
        
        func withdraw(amount: Double) -> Bool {
            if balance >= amount {
                balance -= amount
                print("   取款: -\(amount), 余额: \(balance)")
                return true
            } else {
                print("   取款失败: 余额不足")
                return false
            }
        }
        
        func getBalance() -> Double {
            return balance
        }
    }
}


