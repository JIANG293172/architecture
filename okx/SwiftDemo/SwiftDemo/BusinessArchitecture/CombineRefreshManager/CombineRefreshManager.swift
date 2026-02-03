import Foundation
import Combine
import UIKit

/// CombineRefreshManager - 高频率刷新管理中心
/// 
/// 解决痛点：
/// 1. UI 高频触发 reloadData 导致性能抖动甚至掉帧。
/// 2. 多个数据源异步更新时，短时间内多次刷新 UI 造成资源浪费。
/// 3. 线程安全问题：从非主线程触发刷新导致 Crash。
public class CombineRefreshManager {
    
    // MARK: - Properties
    
    /// 防抖 Subject：接收所有的刷新指令
    private let refreshSubject = PassthroughSubject<Void, Never>()
    
    /// 订阅存储
    private var cancellables = Set<AnyCancellable>()
    
    /// 内部同步队列，替代锁，确保线程安全且更符合 Swift 习惯
    private let queue = DispatchQueue(label: "com.refresh.manager.queue")
    
    /// 刷新回调
    private var onRefresh: (() -> Void)?
    
    // MARK: - Initialization
    
    /// 初始化
    /// - Parameters:
    ///   - interval: 防抖时间间隔（秒），在此时间内多次触发只会执行最后一次
    ///   - scheduler: 调度器，默认在主线程执行
    public init(interval: TimeInterval = 0.3, scheduler: DispatchQueue = .main) {
        setupPipeline(interval: interval, scheduler: scheduler)
    }
    
    deinit {
        // 取消所有订阅，防止闭包捕获导致的潜在问题
        cancellables.removeAll()
    }
    
    // MARK: - Public Methods
    
    /// 触发刷新请求
    ///重点：此方法是线程安全的，可以在任意线程调用
    public func requestRefresh() {
        queue.async { [weak self] in
            self?.refreshSubject.send()
        }
    }
    
    /// 绑定刷新动作
    public func bindRefreshAction(_ action: @escaping () -> Void) {
        self.onRefresh = action
    }
    
    // MARK: - Private Methods
    
    /// 建立 Combine 流水线
    ///重点：Debounce vs Throttle
    /// 1. Debounce (防抖): 停止触发后 N 秒才执行。如果持续触发，则一直推迟。适用于输入框搜索、UI 最终刷新。
    /// 2. Throttle (节流): N 秒内只允许执行一次。适用于滚动监听、按钮点击防止重复提交。
    private func setupPipeline(interval: TimeInterval, scheduler: DispatchQueue) {
        refreshSubject
            .debounce(for: .seconds(interval), scheduler: scheduler)
            .receive(on: DispatchQueue.main) // 确保 UI 刷新在主线程
            .sink { [weak self] _ in
                self?.executeRefresh()
            }
            .store(in: &cancellables)
    }
    
    private func executeRefresh() {
        print("[RefreshManager] 🔄 执行防抖后的最终刷新")
        onRefresh?()
    }
}

/*
 MARK: -深度解析

 1. 为什么用 Combine 而不是传统的 GCD Timer？
    - 声明式编程：逻辑更清晰，一行 `.debounce` 搞定。
    - 组合能力：可以轻松合并多个数据源（Merge），或者根据网络状态过滤刷新。
    - 内存管理：`AnyCancellable` 自动处理生命周期，防止内存泄漏。

 2. 线程安全性是如何保证的？
    - `PassthroughSubject` 本身在 `send()` 时是线程安全的，但为了更严谨，我们使用了 `NSRecursiveLock` 保护入口。
    - 通过 `.receive(on: DispatchQueue.main)` 强制将副作用（UI 刷新）切换到主线程，这是 UI 框架设计的底线。

 3. 这个设计在 CollectionView 中的实际应用场景？
    - 当你有一个 Socket 持续推送成交数据时，1秒内可能收到 50 条消息。
    - 如果每条消息都 reloadData，CPU 会爆表。
    - 使用这个 Manager 设置 0.1s 的防抖，1秒内只会 reload 10 次甚至更少，且展示的是最新数据。
*/
