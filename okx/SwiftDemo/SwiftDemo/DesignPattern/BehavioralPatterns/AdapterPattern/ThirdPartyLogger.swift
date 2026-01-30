//
//  ThirdPartyLogger.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

/// 第三方SDK（接口不兼容：参数/方法名不同）
class ThirdPartyLogger {
    func writeLog(content: String, priority: Int) {
        print("Third-party log: \(content) (priority: \(priority))")
    }
}
