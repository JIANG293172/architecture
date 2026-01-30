//
//  ObserverPatternViewController.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

import UIKit

/// 观察者模式演示视图控制器
/// 观察者模式：定义对象间的一种一对多依赖关系，当一个对象状态发生变化时，所有依赖它的对象都得到通知并被自动更新。
/// 观察者模式的核心组件：
/// 1. 主题（Subject）：被观察的对象，维护观察者列表，提供添加/删除观察者的方法，以及通知观察者的方法
/// 2. 观察者（Observer）：观察主题的对象，实现更新接口，在主题状态变化时接收通知并更新
/// 3. 具体主题（Concrete Subject）：实现主题接口，维护具体状态，当状态变化时通知观察者
/// 4. 具体观察者（Concrete Observer）：实现观察者接口，存储与主题相关的状态，在接收到通知时更新状态
class ObserverPatternViewController: UIViewController {
    /// 输入通知消息的文本字段
    private let messageTextField = UITextField()
    /// 发送通知的按钮
    private let sendButton = UIButton(type: .system)
    /// 显示观察者状态的表格视图
    private let observerTableView = UITableView()
    /// 通知中心（主题）：负责管理观察者和发送通知
    private let notificationCenter = ObserverNotificationCenter()
    /// 观察者数组：存储所有的用户观察者
    private var observers: [UserObserver] = []
    /// 消息数组：存储发送过的消息
    private var messages: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Observer Pattern"
        view.backgroundColor = .white
        setupUI()
        setupActions()
        setupObservers()
    }
    
    /// 设置用户界面
    private func setupUI() {
        // 设置消息文本字段
        messageTextField.frame = CGRect(x: 50, y: 100, width: view.frame.width - 100, height: 40)
        messageTextField.placeholder = "Enter notification message"
        messageTextField.layer.borderWidth = 1.0
        messageTextField.layer.borderColor = UIColor.gray.cgColor
        messageTextField.layer.cornerRadius = 8.0
        view.addSubview(messageTextField)
        
        // 设置发送按钮
        sendButton.frame = CGRect(x: 100, y: 160, width: view.frame.width - 200, height: 44)
        sendButton.setTitle("Send Notification", for: .normal)
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.backgroundColor = .blue
        sendButton.layer.cornerRadius = 22
        view.addSubview(sendButton)
        
        // 设置观察者表格视图
        observerTableView.frame = CGRect(x: 50, y: 220, width: view.frame.width - 100, height: 300)
        observerTableView.layer.borderWidth = 1.0
        observerTableView.layer.borderColor = UIColor.gray.cgColor
        observerTableView.layer.cornerRadius = 8.0
        observerTableView.dataSource = self
        observerTableView.delegate = self
        observerTableView.register(UITableViewCell.self, forCellReuseIdentifier: "ObserverCell")
        view.addSubview(observerTableView)
    }
    
    /// 设置按钮动作
    private func setupActions() {
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
    }
    
    /// 设置观察者
    /// 思路：
    /// 1. 创建多个用户观察者实例
    /// 2. 将这些观察者添加到通知中心
    /// 3. 刷新表格视图显示观察者
    private func setupObservers() {
        // 创建观察者实例
        let observer1 = UserObserver(name: "User 1")
        let observer2 = UserObserver(name: "User 2")
        let observer3 = UserObserver(name: "User 3")
        
        // 存储观察者
        observers = [observer1, observer2, observer3]
        
        // 将观察者添加到通知中心（主题）
        for observer in observers {
            notificationCenter.addObserver(observer)
        }
        
        // 刷新表格视图
        observerTableView.reloadData()
    }
    
    /// 处理发送按钮点击事件
    /// 思路：
    /// 1. 获取用户输入的通知消息
    /// 2. 通过通知中心发送消息给所有观察者
    /// 3. 将消息添加到消息数组
    /// 4. 刷新表格视图显示更新后的观察者状态
    /// 5. 清空文本字段
    @objc private func sendButtonTapped() {
        // 获取通知消息
        guard let message = messageTextField.text, !message.isEmpty else {
            return
        }
        
        // 通过通知中心发送消息：观察者模式的核心操作
        // 当主题（通知中心）发送消息时，所有注册的观察者都会收到通知
        notificationCenter.postMessage(message)
        
        // 添加消息到消息数组
        messages.append(message)
        
        // 刷新表格视图，显示观察者接收到的消息
        observerTableView.reloadData()
        
        // 清空文本字段
        messageTextField.text = ""
    }
}

// MARK: - UITableViewDataSource

extension ObserverPatternViewController: UITableViewDataSource {
    /// 表格视图行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return observers.count
    }
    
    /// 表格视图单元格
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ObserverCell", for: indexPath)
        let observer = observers[indexPath.row]
        // 显示观察者名称和最后收到的消息
        cell.textLabel?.text = "\(observer.name): \(observer.lastMessage)"
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ObserverPatternViewController: UITableViewDelegate {
    /// 表格视图头部标题
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Observers"
    }
}
