//
//  MVVMDemoViewController.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

import UIKit

/// MVVM 架构演示主视图控制器
class MVVMDemoViewController: UIViewController {
    private let startButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MVVM Architecture"
        view.backgroundColor = .white
        setupUI()
        setupActions()
    }
    
    private func setupUI() {
        // 设置开始按钮
        startButton.frame = CGRect(x: 100, y: 200, width: view.frame.width - 200, height: 44)
        startButton.setTitle("Start MVVM Demo", for: .normal)
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
        descriptionLabel.text = "MVVM Architecture Components:\n\nModel: Data layer\nView: UI layer (VC/View)\nViewModel: Mediator with data binding\n\nKey Feature: Data binding between View and ViewModel"
        descriptionLabel.numberOfLines = 0
        view.addSubview(descriptionLabel)
    }
    
    private func setupActions() {
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    @objc private func startButtonTapped() {
        // 创建 MVVM 组件
        let userViewModel = MVVMUserViewModel(userDataService: MVVMUserDataService())
        let userViewController = MVVMUserViewController(viewModel: userViewModel)
        
        // 推送用户列表页面
        let navigationController = UINavigationController(rootViewController: userViewController)
        present(navigationController, animated: true, completion: nil)
    }
}
