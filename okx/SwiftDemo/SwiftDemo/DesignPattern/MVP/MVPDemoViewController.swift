//
//  MVPDemoViewController.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

import UIKit

/// MVP 架构演示主视图控制器
class MVPDemoViewController: UIViewController {
    private let startButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MVP Architecture"
        view.backgroundColor = .white
        setupUI()
        setupActions()
    }
    
    private func setupUI() {
        // 设置开始按钮
        startButton.frame = CGRect(x: 100, y: 200, width: view.frame.width - 200, height: 44)
        startButton.setTitle("Start MVP Demo", for: .normal)
        startButton.setTitleColor(.white, for: .normal)
        startButton.backgroundColor = .blue
        startButton.layer.cornerRadius = 22
        view.addSubview(startButton)
        
        // 设置说明标签
        let descriptionLabel = UILabel()
        descriptionLabel.frame = CGRect(x: 50, y: 300, width: view.frame.width - 100, height: 150)
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = .black
        descriptionLabel.text = "MVP Architecture Components:\n\nModel: Data layer\nView: UI layer (VC/View)\nPresenter: Mediator between View and Model\n\nKey Feature: Presenter has direct references to View"
        descriptionLabel.numberOfLines = 0
        view.addSubview(descriptionLabel)
    }
    
    private func setupActions() {
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    @objc private func startButtonTapped() {
        // 创建 MVP 组件
        let userPresenter = UserPresenter(userDataService: UserDataService())
        let userViewController = UserViewController(presenter: userPresenter)
        let navigationController = UINavigationController(rootViewController: userViewController)
        
        // 展示用户列表页面
        present(navigationController, animated: true, completion: nil)
    }
}
