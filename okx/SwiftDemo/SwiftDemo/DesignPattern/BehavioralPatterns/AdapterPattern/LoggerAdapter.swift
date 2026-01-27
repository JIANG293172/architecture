//
//  LoggerAdapter.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

/// 日志适配器：实现适配器模式
/// 作用：将第三方日志库的接口转换为应用程序所需的接口
/// 适配器模式的核心组件：
/// 1. 目标接口（AppLogger）：客户端期望的接口
/// 2. 适配器（LoggerAdapter）：实现目标接口，同时封装被适配者
/// 3. 被适配者（ThirdPartyLogger）：需要被适配的现有接口
class LoggerAdapter: AppLogger {
    /// 被适配的第三方日志库实例
    private let thirdPartyLogger = ThirdPartyLogger()
    
    /// 实现AppLogger协议的log方法
    /// 思路：
    /// 1. 接收应用程序的日志消息和级别
    /// 2. 将应用程序的日志级别转换为第三方日志库的优先级
    /// 3. 调用第三方日志库的writeLog方法记录日志
    /// - Parameters:
    ///   - message: 日志消息
    ///   - level: 日志级别（"info"或"error"）
    func log(message: String, level: String) {
        // 将应用程序的日志级别转换为第三方日志库的优先级
        // "error"级别对应优先级1，其他级别对应优先级0
        let priority = level == "error" ? 1 : 0
        
        // 调用第三方日志库的方法记录日志
        // 这里将message参数映射为content参数，level参数转换为priority参数
        thirdPartyLogger.writeLog(content: message, priority: priority)
    }
}

/// 应用程序日志接口（目标接口）
protocol AppLogger {
    /// 记录日志
    /// - Parameters:
    ///   - message: 日志消息
    ///   - level: 日志级别
    func log(message: String, level: String)
}

/// 第三方日志库（被适配者）
class ThirdPartyLogger {
    /// 写入日志
    /// - Parameters:
    ///   - content: 日志内容
    ///   - priority: 日志优先级（0: 普通, 1: 错误）
    func writeLog(content: String, priority: Int) {
        // 实际的日志记录逻辑
        print("ThirdPartyLogger: [Priority \(priority)] \(content)")
    }
}
