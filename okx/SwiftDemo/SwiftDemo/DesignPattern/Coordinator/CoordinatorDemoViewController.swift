//
//  CoordinatorDemoViewController.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

import UIKit

/// Coordinator 架构演示页面视图控制器
class CoordinatorDemoViewController: UIViewController {
    private var coordinator: MainCoordinator?
    private let startButton = UIButton(type: .system)
    private let descriptionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Coordinator Demo"
        view.backgroundColor = .white
        setupUI()
        setupActions()
    }
    
    private func setupUI() {
        // Setup description label
        descriptionLabel.frame = CGRect(x: 20, y: 100, width: view.frame.width - 40, height: 100)
        descriptionLabel.text = "Coordinator Architecture Demo\n\n- Navigation logic separated from ViewControllers\n- Clear separation of concerns\n- Easy to test and maintain\n- Scalable for large applications"
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = .black
        view.addSubview(descriptionLabel)
        
        // Setup start button
        startButton.frame = CGRect(x: 100, y: 250, width: view.frame.width - 200, height: 50)
        startButton.setTitle("Start Demo", for: .normal)
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
        // 创建导航控制器
        let navigationController = UINavigationController()
        
        // 创建主协调器
        coordinator = MainCoordinator(navigationController: navigationController)
        
        // 启动协调器
        coordinator?.start()
        
        // 显示导航控制器
        present(navigationController, animated: true, completion: nil)
    }
}
