//
//  ObserverNotificationCenter.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

/// 通知中心类，实现了 Subject 协议
class ObserverNotificationCenter: Subject {
    private var observers: [Observer] = []
    private var message: String = ""
    
    /// 添加观察者
    /// - Parameter observer: 要添加的观察者
    func addObserver(_ observer: Observer) {
        observers.append(observer)
    }
    
    /// 移除观察者
    /// - Parameter observer: 要移除的观察者
    func removeObserver(_ observer: Observer) {
        if let index = observers.firstIndex(where: { $0 === observer }) {
            observers.remove(at: index)
        }
    }
    
    /// 通知所有观察者
    /// - Parameter message: 要通知给观察者的消息
    func notifyObservers(message: String) {
        for observer in observers {
            observer.update(message: message)
        }
    }
    
    /// 设置消息并通知所有观察者
    /// - Parameter message: 要发送的消息
    func postMessage(_ message: String) {
        self.message = message
        notifyObservers(message: message)
    }
}
