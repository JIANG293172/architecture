import Foundation
import UIKit

/// 卡顿检测器，用于检测主线程卡顿情况
class StutterMonitor {
    /// 单例实例
    static let shared = StutterMonitor()
    
    /// 是否正在监控
    var isMonitoring: Bool = false
    /// 监控线程
    private var monitorThread: Thread?
    
    /// 启动监控
    func startMonitor() {
        guard !isMonitoring else { return }
        isMonitoring = true
        
        print("🔄 开始监控主线程卡顿")
        
        // 创建并启动监控线程
        monitorThread = Thread(target: self, selector: #selector(monitorThreadEntry), object: nil)
        monitorThread?.start()
    }
    
    /// 停止监控
    func stopMonitor() {
        guard isMonitoring else { return }
        isMonitoring = false
        
        // 停止监控线程
        monitorThread?.cancel()
        monitorThread = nil
        
        print("🛑 停止监控主线程卡顿")
    }
    
    /// 监控线程入口
    @objc private func monitorThreadEntry() {
        autoreleasepool {
            while !Thread.current.isCancelled {
                // 记录当前时间
                let startTime = Date().timeIntervalSince1970
                
                // 在主线程执行一个空任务，测量执行时间
                DispatchQueue.main.sync {
                    // 空任务，只是为了测量主线程的响应速度
                }
                
                // 计算执行时间
                let executionTime = Date().timeIntervalSince1970 - startTime
                
                // 如果执行时间超过 50ms，认为可能存在卡顿
                if executionTime > 0.05 {
                    print("⚠️ 主线程卡顿检测：执行时间 \(executionTime * 1000)ms")
                    captureMainThreadCallStack()
                }
                
                // 每 100ms 检查一次
                Thread.sleep(forTimeInterval: 0.1)
            }
        }
    }
    
    /// 捕获主线程调用栈
    private func captureMainThreadCallStack() {
        print("📋 捕获主线程调用栈：")
        
        // 简单的调用栈打印
        for symbol in Thread.callStackSymbols {
            print("   \(symbol)")
        }
    }
}
