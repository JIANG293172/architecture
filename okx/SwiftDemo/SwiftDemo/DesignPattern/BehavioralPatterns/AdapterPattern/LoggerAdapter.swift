//
//  LoggerAdapter.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

/// 适配器：将第三方接口适配为AppLogger
class LoggerAdapter: AppLogger {
    private let thirdPartyLogger = ThirdPartyLogger()
    /// 转换参数+方法名
    func log(message: String, level: String) {
        let priority = level == "error" ? 1 : 0
        thirdPartyLogger.writeLog(content: message, priority: priority)
    }
}
