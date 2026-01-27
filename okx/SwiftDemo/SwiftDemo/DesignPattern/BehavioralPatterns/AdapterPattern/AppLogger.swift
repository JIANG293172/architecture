//
//  AppLogger.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

/// 客户端期望的接口（项目内统一的日志接口）
protocol AppLogger {
    func log(message: String, level: String)
}
