//
//  SubjectProtocol.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

/// 主题协议，定义了主题需要实现的方法
protocol Subject {
    /// 添加观察者
    /// - Parameter observer: 要添加的观察者
    func addObserver(_ observer: Observer)
    
    /// 移除观察者
    /// - Parameter observer: 要移除的观察者
    func removeObserver(_ observer: Observer)
    
    /// 通知所有观察者
    /// - Parameter message: 要通知给观察者的消息
    func notifyObservers(message: String)
}
