//
//  UserObserver.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

/// 用户观察者类，实现了 Observer 协议
class UserObserver: Observer {
    private let name: String
    var lastMessage: String = ""
    
    /// 初始化方法
    /// - Parameter name: 观察者名称
    init(name: String) {
        self.name = name
    }
    
    /// 当主题状态变化时，会调用此方法通知观察者
    /// - Parameter message: 主题传递给观察者的消息
    func update(message: String) {
        lastMessage = message
        print("\(name) received message: \(message)")
    }
}
