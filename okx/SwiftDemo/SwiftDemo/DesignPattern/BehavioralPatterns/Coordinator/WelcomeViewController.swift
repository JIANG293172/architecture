//
//  WelcomeViewController.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

import UIKit

/// 欢迎页面视图控制器
class WelcomeViewController: UIViewController {
    /// 协调器
    weak var coordinator: MainCoordinator?
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let startButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Welcome"
        view.backgroundColor = .white
        setupUI()
        setupActions()
    }
    
    private func setupUI() {
        // Setup title label
        titleLabel.frame = CGRect(x: 50, y: 200, width: view.frame.width - 100, height: 50)
        titleLabel.text = "Welcome to Coordinator Demo"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = .black
        view.addSubview(titleLabel)
        
        // Setup subtitle label
        subtitleLabel.frame = CGRect(x: 50, y: 260, width: view.frame.width - 100, height: 30)
        subtitleLabel.text = "A simple demo of Coordinator architecture"
        subtitleLabel.textAlignment = .center
        subtitleLabel.font = UIFont.systemFont(ofSize: 16)
        subtitleLabel.textColor = .gray
        view.addSubview(subtitleLabel)
        
        // Setup start button
        startButton.frame = CGRect(x: 100, y: 350, width: view.frame.width - 200, height: 50)
        startButton.setTitle("Get Started", for: .normal)
        startButton.setTitleColor(.white, for: .normal)
        startButton.backgroundColor = .blue
        startButton.layer.cornerRadius = 25
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        view.addSubview(startButton)
    }
    
    private func setupActions() {
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    @objc private func startButtonTapped() {
        coordinator?.showUserListViewController()
    }
}
