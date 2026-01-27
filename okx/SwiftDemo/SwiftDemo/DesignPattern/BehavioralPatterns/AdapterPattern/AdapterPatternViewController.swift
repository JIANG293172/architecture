//
//  AdapterPatternViewController.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

import UIKit

/// 适配器模式演示视图控制器
class AdapterPatternViewController: UIViewController {
    private let messageTextField = UITextField()
    private let levelSegmentedControl = UISegmentedControl()
    private let logButton = UIButton(type: .system)
    private let logTextView = UITextView()
    private var logs: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Adapter Pattern"
        view.backgroundColor = .white
        setupUI()
        setupActions()
    }
    
    private func setupUI() {
        // Setup message text field
        messageTextField.frame = CGRect(x: 50, y: 100, width: view.frame.width - 100, height: 40)
        messageTextField.layer.borderWidth = 1.0
        messageTextField.layer.borderColor = UIColor.gray.cgColor
        messageTextField.layer.cornerRadius = 8.0
        messageTextField.placeholder = "Enter log message"
        view.addSubview(messageTextField)
        
        // Setup level segmented control
        levelSegmentedControl.frame = CGRect(x: 50, y: 160, width: view.frame.width - 100, height: 40)
        levelSegmentedControl.insertSegment(withTitle: "Info", at: 0, animated: false)
        levelSegmentedControl.insertSegment(withTitle: "Error", at: 1, animated: false)
        levelSegmentedControl.selectedSegmentIndex = 0
        view.addSubview(levelSegmentedControl)
        
        // Setup log button
        logButton.frame = CGRect(x: 100, y: 220, width: view.frame.width - 200, height: 44)
        logButton.setTitle("Log Message", for: .normal)
        logButton.setTitleColor(.white, for: .normal)
        logButton.backgroundColor = .blue
        logButton.layer.cornerRadius = 22
        view.addSubview(logButton)
        
        // Setup log text view
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
    
    private func setupActions() {
        logButton.addTarget(self, action: #selector(logButtonTapped), for: .touchUpInside)
    }
    
    @objc private func logButtonTapped() {
        // Get log message from text field
        guard let message = messageTextField.text, !message.isEmpty else {
            updateLogTextView(text: "Please enter a log message")
            return
        }
        
        // Get selected log level
        let level = levelSegmentedControl.selectedSegmentIndex == 0 ? "info" : "error"
        
        // Create logger adapter
        let logger: AppLogger = LoggerAdapter()
        
        // Log message through adapter
        logger.log(message: message, level: level)
        
        // Update log text view
        let logEntry = "[\(level.uppercased())] \(message)"
        updateLogTextView(text: logEntry)
    }
    
    private func updateLogTextView(text: String) {
        logs.append(text)
        logTextView.text = "Log Output:\n" + logs.joined(separator: "\n")
        // Scroll to bottom
        let bottom = NSMakeRange(logTextView.text.count - 1, 1)
        logTextView.scrollRangeToVisible(bottom)
    }
}
