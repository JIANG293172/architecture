import Foundation

/// 性能监控器，用于监控应用性能指标
/// 最佳实践：结合多种监控方式，提供低开销、准确的性能数据
class PerformanceMonitor {
    /// 单例实例
    static let shared = PerformanceMonitor()
    
    /// 配置参数
    struct Configuration {
        /// 卡顿阈值（毫秒）
        let stutterThreshold: TimeInterval = 50
        /// 监控间隔（毫秒）
        let monitorInterval: TimeInterval = 200
        /// 最大等待时间（秒）
        let maxWaitTime: TimeInterval = 1
        /// 是否启用详细日志
        let enableDetailedLogging: Bool = true
    }
    
    /// 监控状态
    private var isMonitoring: Bool = false
    /// 监控线程
    private var monitorThread: Thread?
    /// 配置
    private let config: Configuration = Configuration()
    /// 线程安全锁
    private let lock = NSLock()
    /// 卡顿统计
    private var stutterCount: Int = 0
    private var totalStutterTime: TimeInterval = 0
    private var maxStutterTime: TimeInterval = 0
    
    /// 启动性能监控
    func startMonitoring() {
        lock.lock()
        defer { lock.unlock() }
        
        guard !isMonitoring else { return }
        isMonitoring = true
        
        if config.enableDetailedLogging {
            print("🔄 开始性能监控")
            print("📊 监控配置：")
            print("   - 卡顿阈值：\(config.stutterThreshold)ms")
            print("   - 监控间隔：\(config.monitorInterval)ms")
        }
        
        // 创建并启动监控线程
        let thread = Thread {
            self.monitorThreadEntry()
        }
        thread.name = "PerformanceMonitorThread"
        thread.start()
        monitorThread = thread
    }
    
    /// 停止性能监控
    func stopMonitoring() {
        lock.lock()
        defer { lock.unlock() }
        
        guard isMonitoring else { return }
        isMonitoring = false
        
        // 停止监控线程
        monitorThread?.cancel()
        monitorThread = nil
        
        if config.enableDetailedLogging {
            print("🛑 停止性能监控")
            print("📊 监控统计：")
            print("   - 卡顿次数：\(stutterCount)")
            print("   - 总卡顿时间：\(totalStutterTime * 1000)ms")
            print("   - 最大卡顿时间：\(maxStutterTime * 1000)ms")
            // 重置统计
            stutterCount = 0
            totalStutterTime = 0
            maxStutterTime = 0
        }
    }
    
    /// 监控线程入口
    private func monitorThreadEntry() {
        autoreleasepool {
            // 延迟执行，给主线程一些时间
            Thread.sleep(forTimeInterval: 0.5)
            
            while !Thread.current.isCancelled {
                // 检查是否应该继续监控
                lock.lock()
                let shouldContinue = isMonitoring
                lock.unlock()
                
                guard shouldContinue else { break }
                
                monitorMainThreadResponsiveness()
                
                // 控制监控频率
                Thread.sleep(forTimeInterval: config.monitorInterval / 1000)
            }
        }
    }
    
    /// 监控主线程响应性
    private func monitorMainThreadResponsiveness() {
        let semaphore = DispatchSemaphore(value: 0)
        let startTime = Date().timeIntervalSince1970
        
        // 在主线程执行任务，测量响应时间
        DispatchQueue.main.async {
            // 执行一个轻量级任务，模拟主线程工作
            // 这里可以添加额外的检查，如RunLoop状态
            semaphore.signal()
        }
        
        // 等待主线程响应
        let timeout = DispatchTime.now() + config.maxWaitTime
        _ = semaphore.wait(timeout: timeout)
        let executionTime = Date().timeIntervalSince1970 - startTime
        
        // 检查是否发生卡顿
        if executionTime * 1000 > config.stutterThreshold {
            handleStutter(duration: executionTime)
        }
    }
    
    /// 处理卡顿事件
    /// - Parameter duration: 卡顿持续时间（秒）
    private func handleStutter(duration: TimeInterval) {
        lock.lock()
        stutterCount += 1
        totalStutterTime += duration
        if duration > maxStutterTime {
            maxStutterTime = duration
        }
        lock.unlock()
        
        if config.enableDetailedLogging {
            print("⚠️ 主线程卡顿检测：执行时间 \(duration * 1000)ms")
            captureMainThreadCallStack()
        }
        
        // 这里可以添加：
        // 1. 卡顿数据上报
        // 2. 自动保存崩溃日志
        // 3. 与其他监控系统集成
    }
    
    /// 捕获主线程调用栈
    private func captureMainThreadCallStack() {
        print("📋 捕获主线程调用栈：")
        
        // 获取当前线程的调用栈
        // 注意：要获取主线程的真实调用栈，需要在主线程中执行
        DispatchQueue.main.async {
            print("   [主线程调用栈开始]")
            for (index, symbol) in Thread.callStackSymbols.enumerated() {
                // 跳过前几个系统调用，只显示应用相关的调用
                if index > 2 {
                    print("   \(symbol)")
                }
            }
            print("   [主线程调用栈结束]")
        }
    }
    
    /// 获取当前监控状态
    func getMonitoringStatus() -> Bool {
        lock.lock()
        defer { lock.unlock() }
        return isMonitoring
    }
    
    /// 获取性能统计数据
    func getPerformanceStats() -> (stutterCount: Int, totalStutterTime: TimeInterval, maxStutterTime: TimeInterval) {
        lock.lock()
        defer { lock.unlock() }
        return (stutterCount, totalStutterTime, maxStutterTime)
    }
}

/// 性能监控扩展：提供便捷的使用方法
extension PerformanceMonitor {
    /// 快速启动监控
    static func start() {
        shared.startMonitoring()
    }
    
    /// 快速停止监控
    static func stop() {
        shared.stopMonitoring()
    }
    
    /// 检查是否正在监控
    static var isActive: Bool {
        return shared.getMonitoringStatus()
    }
    
    /// 获取性能统计
    static func stats() -> (stutterCount: Int, totalStutterTime: TimeInterval, maxStutterTime: TimeInterval) {
        return shared.getPerformanceStats()
    }
}

/// 向后兼容：保留原有的StutterMonitor类名
class StutterMonitor {
    static let shared = StutterMonitor()
    
    func startMonitor() {
        PerformanceMonitor.start()
    }
    
    func stopMonitor() {
        PerformanceMonitor.stop()
    }
}
