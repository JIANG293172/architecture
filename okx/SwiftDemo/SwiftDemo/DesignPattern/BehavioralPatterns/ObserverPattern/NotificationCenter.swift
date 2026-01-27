//
//  ObserverNotificationCenter.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

/// 通知中心类：观察者模式的主题（Subject）实现
/// 作用：管理观察者列表，提供添加/删除观察者的方法，以及发送通知的方法
/// 观察者模式中的具体主题：
/// 1. 维护观察者列表
/// 2. 实现主题接口的方法
/// 3. 当状态变化时通知所有观察者
class ObserverNotificationCenter: Subject {
    /// 观察者列表：存储所有注册的观察者
    private var observers: [Observer] = []
    /// 当前消息：存储要发送的消息
    private var message: String = ""
    
    /// 添加观察者
    /// - Parameter observer: 要添加的观察者
    /// 思路：将观察者添加到观察者列表中
    func addObserver(_ observer: Observer) {
        observers.append(observer)
    }
    
    /// 移除观察者
    /// - Parameter observer: 要移除的观察者
    /// 思路：在观察者列表中查找并移除指定的观察者
    func removeObserver(_ observer: Observer) {
        // 使用 === 运算符进行身份比较，确保移除正确的观察者实例
        if let index = observers.firstIndex(where: { $0 === observer }) {
            observers.remove(at: index)
        }
    }
    
    /// 通知所有观察者
    /// - Parameter message: 要通知给观察者的消息
    /// 思路：遍历观察者列表，调用每个观察者的update方法
    func notifyObservers(message: String) {
        // 遍历所有注册的观察者，发送通知
        for observer in observers {
            observer.update(message: message)
        }
    }
    
    /// 设置消息并通知所有观察者
    /// - Parameter message: 要发送的消息
    /// 思路：
    /// 1. 存储消息
    /// 2. 调用notifyObservers方法通知所有观察者
    func postMessage(_ message: String) {
        // 存储消息
        self.message = message
        // 通知所有观察者：观察者模式的核心操作
        notifyObservers(message: message)
    }
}
