import Foundation
import UIKit
import QuartzCore

/// RunLoop 卡顿监控器
/// 思路：通过观察 RunLoop 的运行状态，检测主线程卡顿
class RunloopMonitor {
    
    /// 监控器单例
    static let shared = RunloopMonitor()
    
    /// 监控回调闭包
    typealias MonitorCallback = (TimeInterval) -> Void
    
    /// 监控回调
    private var monitorCallback: MonitorCallback?
    
    /// RunLoop 观察者
    private var runLoopObserver: CFRunLoopObserver?
    
    /// 监控线程
    private var monitorThread: Thread?
    
    /// 上次 RunLoop 活动时间
    private var lastActivityTime: TimeInterval = 0
    
    /// 卡顿阈值（秒）
    private let stutterThreshold: TimeInterval = 0.1
    
    /// 是否正在监控
    private var isMonitoring: Bool = false
    
    /// 队列锁
    private let lock = NSLock()
    
    /// 开始监控
    /// - Parameter callback: 监控回调，参数为卡顿持续时间
    func startMonitoring(callback: @escaping MonitorCallback) {
        lock.lock()
        defer { lock.unlock() }
        
        guard !isMonitoring else { return }
        
        monitorCallback = callback
        isMonitoring = true
        
        // 创建监控线程
        monitorThread = Thread(target: self, selector: #selector(monitorRunLoop), object: nil)
        monitorThread?.name = "RunloopMonitorThread"
        monitorThread?.start()
    }
    
    /// 停止监控
    func stopMonitoring() {
        lock.lock()
        defer { lock.unlock() }
        
        guard isMonitoring else { return }
        
        isMonitoring = false
        
        // 取消 RunLoop 观察者
        if let observer = runLoopObserver {
            CFRunLoopRemoveObserver(CFRunLoopGetMain(), observer, CFRunLoopMode.commonModes)
            runLoopObserver = nil
        }
        
        // 取消监控线程
        monitorThread?.cancel()
        monitorThread = nil
        
        monitorCallback = nil
    }
    
//    ### 1. 避免影响主线程性能
//    - 监控逻辑独立 ：监控线程负责管理监听器的生命周期（如启动/停止、状态维护），其自身的运行不会占用主线程资源。
//    - 无性能开销 ：即使监控线程执行一些管理操作（如日志记录、状态更新），也不会影响主线程的事件处理和 UI 渲染。
//    ### 2. 确保监听器持续存在
//    - 生命周期管理 ：监控线程会持续运行（通过 CFRunLoopRunInMode 保持活跃），确保 RunLoop 观察者不会因主线程的状态变化而被意外释放。
//    - 避免被主线程阻塞 ：如果在主线程管理监听器，当主线程因卡顿而阻塞时，监控逻辑本身也会被阻塞，无法及时触发卡顿回调。
//    ### 3. 隔离监控与业务逻辑
//    - 职责分离 ：监控逻辑（如计算卡顿时间、触发回调）与业务逻辑完全分离，提高代码的可读性和可维护性。
//    - 模块化设计 ：监控线程可以独立封装，便于后续扩展（如添加更多性能监控指标）。
//    ### 4. 技术实现的必要性
//    - 跨线程观察 ： CFRunLoopObserver 支持跨线程注册（即从监控线程注册到主线程的 RunLoop），这种设计天然适合通过独立线程管理。
//    - 线程安全 ：监控线程通过 NSLock 保护共享变量（如 isMonitoring ），避免多线程竞争问题。
    /// 监控 RunLoop
    @objc private func monitorRunLoop() {
        // 在监控线程中设置 RunLoop 观察者
        let runLoop = CFRunLoopGetCurrent()
        
        
        // 创建 RunLoop 观察者
        runLoopObserver = CFRunLoopObserverCreateWithHandler(nil, CFRunLoopActivity.allActivities.rawValue, true, 0) { [weak self] (observer, activity) in
            guard let self = self else { return }
            
            // 处理 RunLoop 活动
            self.handleRunLoopActivity(activity)
        }
        
        // 添加观察者到主线程 RunLoop
        if let observer = runLoopObserver {
            CFRunLoopAddObserver(CFRunLoopGetMain(), observer, CFRunLoopMode.commonModes)
        }
        
        // 让监控线程的 RunLoop 保持运行
        while !Thread.current.isCancelled {
            CFRunLoopRunInMode(.defaultMode, 1.0, false)
        }
    }
    
    /// 处理 RunLoop 活动
//    比如处理过程中，又有事件输入，这个事件不会放到当前的循环处理，会放到下个循环， 当前循环事件处理完之后， 还是会进入  beforewaiting ，然后立即进入 aftewaiting 处理后面的事件
//    ### RunLoop 处理新事件的完整流程
//    1. 当前循环处理 ：RunLoop 处理当前队列中的事件（如事件 A）。
//    2. 新事件输入 ：在处理事件 A 过程中，用户触发触摸事件 B → 事件 B 被添加到事件队列。
//    3. 当前循环结束 ：事件 A 处理完成后，RunLoop 完成当前循环的所有待处理事件。
//    4. 进入等待状态 ：RunLoop 进入 beforeWaiting 状态，准备休眠以等待新事件。
//    5. 检测到新事件 ：RunLoop 发现队列中已有事件 B， 不会真正休眠 。
//    6. 唤醒处理 ：立即进入 afterWaiting 状态，开始处理事件 B。
//    7. 下一次循环 ：处理完事件 B 后，RunLoop 可能进入下一次循环（如果还有新事件），或再次进入等待状态。
    
    private func handleRunLoopActivity(_ activity: CFRunLoopActivity) {
        let currentTime = CACurrentMediaTime()
        
        // 当 RunLoop 进入休眠或处理事件时
        switch activity {
        case .entry, .beforeTimers, .beforeSources:
            // 记录开始时间
            lastActivityTime = currentTime
            
        case .afterWaiting, .exit:
            // 计算处理时间
            let processTime = currentTime - lastActivityTime
            
            // 如果处理时间超过阈值，认为发生了卡顿
            if processTime > stutterThreshold {
                monitorCallback?(processTime)
            }
            
        default:
            break
        }
    }
}
