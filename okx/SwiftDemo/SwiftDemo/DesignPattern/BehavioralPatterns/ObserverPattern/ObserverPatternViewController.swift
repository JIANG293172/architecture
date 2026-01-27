//
//  ObserverPatternViewController.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

import UIKit

/// 观察者模式演示视图控制器
class ObserverPatternViewController: UIViewController {
    private let messageTextField = UITextField()
    private let sendButton = UIButton(type: .system)
    private let observerTableView = UITableView()
    private let notificationCenter = ObserverNotificationCenter()
    private var observers: [UserObserver] = []
    private var messages: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Observer Pattern"
        view.backgroundColor = .white
        setupUI()
        setupActions()
        setupObservers()
    }
    
    private func setupUI() {
        // Setup message text field
        messageTextField.frame = CGRect(x: 50, y: 100, width: view.frame.width - 100, height: 40)
        messageTextField.placeholder = "Enter notification message"
        messageTextField.layer.borderWidth = 1.0
        messageTextField.layer.borderColor = UIColor.gray.cgColor
        messageTextField.layer.cornerRadius = 8.0
        view.addSubview(messageTextField)
        
        // Setup send button
        sendButton.frame = CGRect(x: 100, y: 160, width: view.frame.width - 200, height: 44)
        sendButton.setTitle("Send Notification", for: .normal)
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.backgroundColor = .blue
        sendButton.layer.cornerRadius = 22
        view.addSubview(sendButton)
        
        // Setup observer table view
        observerTableView.frame = CGRect(x: 50, y: 220, width: view.frame.width - 100, height: 300)
        observerTableView.layer.borderWidth = 1.0
        observerTableView.layer.borderColor = UIColor.gray.cgColor
        observerTableView.layer.cornerRadius = 8.0
        observerTableView.dataSource = self
        observerTableView.delegate = self
        observerTableView.register(UITableViewCell.self, forCellReuseIdentifier: "ObserverCell")
        view.addSubview(observerTableView)
    }
    
    private func setupActions() {
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
    }
    
    private func setupObservers() {
        // Create and add observers
        let observer1 = UserObserver(name: "User 1")
        let observer2 = UserObserver(name: "User 2")
        let observer3 = UserObserver(name: "User 3")
        
        observers = [observer1, observer2, observer3]
        
        for observer in observers {
            notificationCenter.addObserver(observer)
        }
        
        observerTableView.reloadData()
    }
    
    @objc private func sendButtonTapped() {
        // Get message from text field
        guard let message = messageTextField.text, !message.isEmpty else {
            return
        }
        
        // Post message to notification center
        notificationCenter.postMessage(message)
        
        // Add message to messages array
        messages.append(message)
        
        // Reload table view to show updated messages
        observerTableView.reloadData()
        
        // Clear text field
        messageTextField.text = ""
    }
}

// MARK: - UITableViewDataSource

extension ObserverPatternViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return observers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ObserverCell", for: indexPath)
        let observer = observers[indexPath.row]
        cell.textLabel?.text = "\(observer.name): \(observer.lastMessage)"
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ObserverPatternViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Observers"
    }
}
