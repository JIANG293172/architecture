//
//  UserObserver.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

/// 用户观察者类：观察者模式的具体观察者实现
/// 作用：接收主题（通知中心）发送的通知，并更新自身状态
/// 观察者模式中的具体观察者：
/// 1. 实现观察者接口（Observer）
/// 2. 存储与主题相关的状态
/// 3. 在接收到通知时更新状态
class UserObserver: Observer {
    /// 观察者名称
    let name: String
    /// 最后收到的消息：存储观察者的状态
    var lastMessage: String = ""
    
    /// 初始化方法
    /// - Parameter name: 观察者名称
    init(name: String) {
        self.name = name
    }
    
    /// 当主题状态变化时，会调用此方法通知观察者
    /// - Parameter message: 主题传递给观察者的消息
    /// 思路：
    /// 1. 更新观察者的状态（存储最后收到的消息）
    /// 2. 打印收到的消息（模拟处理通知）
    func update(message: String) {
        // 更新观察者的状态
        lastMessage = message
        // 打印收到的消息，模拟观察者对通知的处理
        print("\(name) received message: \(message)")
    }
}
