//
//  ObserverProtocol.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

/// 观察者协议，定义了观察者需要实现的更新方法
protocol Observer: AnyObject {
    /// 当主题状态变化时，会调用此方法通知观察者
    /// - Parameter message: 主题传递给观察者的消息
    func update(message: String)
}
