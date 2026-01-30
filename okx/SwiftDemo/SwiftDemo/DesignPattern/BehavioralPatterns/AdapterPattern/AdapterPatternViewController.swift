//
//  AdapterPatternViewController.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

import UIKit

/// 适配器模式演示视图控制器
/// 适配器模式：将一个类的接口转换成客户端期望的另一个接口，使原本由于接口不兼容而不能一起工作的类可以协同工作。
class AdapterPatternViewController: UIViewController {
    /// 输入日志消息的文本字段
    private let messageTextField = UITextField()
    /// 选择日志级别的分段控件
    private let levelSegmentedControl = UISegmentedControl()
    /// 触发日志记录的按钮
    private let logButton = UIButton(type: .system)
    /// 显示日志输出的文本视图
    private let logTextView = UITextView()
    /// 存储日志条目
    private var logs: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Adapter Pattern"
        view.backgroundColor = .white
        setupUI()
        setupActions()
    }
    
    /// 设置用户界面
    private func setupUI() {
        // 设置文本字段，用于输入日志消息
        messageTextField.frame = CGRect(x: 50, y: 100, width: view.frame.width - 100, height: 40)
        messageTextField.layer.borderWidth = 1.0
        messageTextField.layer.borderColor = UIColor.gray.cgColor
        messageTextField.layer.cornerRadius = 8.0
        messageTextField.placeholder = "Enter log message"
        view.addSubview(messageTextField)
        
        // 设置分段控件，用于选择日志级别
        levelSegmentedControl.frame = CGRect(x: 50, y: 160, width: view.frame.width - 100, height: 40)
        levelSegmentedControl.insertSegment(withTitle: "Info", at: 0, animated: false)
        levelSegmentedControl.insertSegment(withTitle: "Error", at: 1, animated: false)
        levelSegmentedControl.selectedSegmentIndex = 0
        view.addSubview(levelSegmentedControl)
        
        // 设置日志按钮
        logButton.frame = CGRect(x: 100, y: 220, width: view.frame.width - 200, height: 44)
        logButton.setTitle("Log Message", for: .normal)
        logButton.setTitleColor(.white, for: .normal)
        logButton.backgroundColor = .blue
        logButton.layer.cornerRadius = 22
        view.addSubview(logButton)
        
        // 设置日志文本视图，用于显示输出
        logTextView.frame = CGRect(x: 50, y: 280, width: view.frame.width - 100, height: 200)
        logTextView.backgroundColor = .lightGray
        logTextView.textColor = .black
        logTextView.font = UIFont.systemFont(ofSize: 16)
        logTextView.text = "Log Output:\n"
        logTextView.isEditable = false
        logTextView.layer.borderWidth = 1.0
        logTextView.layer.borderColor = UIColor.gray.cgColor
        logTextView.layer.cornerRadius = 8.0
        view.addSubview(logTextView)
    }
    
    /// 设置按钮动作
    private func setupActions() {
        logButton.addTarget(self, action: #selector(logButtonTapped), for: .touchUpInside)
    }
    
    /// 处理日志按钮点击事件
    /// 思路：
    /// 1. 获取用户输入的日志消息和选择的日志级别
    /// 2. 创建日志适配器实例（LoggerAdapter）
    /// 3. 通过适配器调用日志方法，实现不同日志系统的兼容
    /// 4. 更新日志文本视图，显示日志条目
    @objc private func logButtonTapped() {
        // 获取日志消息
        guard let message = messageTextField.text, !message.isEmpty else {
            updateLogTextView(text: "Please enter a log message")
            return
        }
        
        // 获取选择的日志级别
        let level = levelSegmentedControl.selectedSegmentIndex == 0 ? "info" : "error"
        
        // 创建日志适配器：这里是适配器模式的核心
        // LoggerAdapter 实现了 AppLogger 协议，同时内部封装了 ThirdPartyLogger
        // 它将 AppLogger 的接口转换为 ThirdPartyLogger 可以理解的接口
        let logger: AppLogger = LoggerAdapter()
        
        // 通过适配器记录日志
        // 客户端代码只需要知道 AppLogger 协议，不需要知道具体的日志实现
        logger.log(message: message, level: level)
        
        // 更新日志文本视图
        let logEntry = "[\(level.uppercased())] \(message)"
        updateLogTextView(text: logEntry)
    }
    
    /// 更新日志文本视图
    /// - Parameter text: 要添加的日志文本
    private func updateLogTextView(text: String) {
        // 添加新的日志条目
        logs.append(text)
        // 更新文本视图内容
        logTextView.text = "Log Output:\n" + logs.joined(separator: "\n")
        // 滚动到文本视图底部，确保最新的日志可见
        let bottom = NSMakeRange(logTextView.text.count - 1, 1)
        logTextView.scrollRangeToVisible(bottom)
    }
}
