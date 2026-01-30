//
//  VIPERDemoViewController.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

import UIKit

/// VIPER 架构演示主视图控制器
class VIPERDemoViewController: UIViewController {
    private let startButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "VIPER Architecture"
        view.backgroundColor = .white
        setupUI()
        setupActions()
    }
    
    private func setupUI() {
        // 设置开始按钮
        startButton.frame = CGRect(x: 100, y: 200, width: view.frame.width - 200, height: 44)
        startButton.setTitle("Start VIPER Demo", for: .normal)
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
        descriptionLabel.text = "VIPER Architecture Components:\n\nView: UI layer (VC/View)\nInteractor: Business logic layer\nPresenter: Mediator between View and Interactor\nEntity: Raw data model\nRouter: Navigation logic"
        descriptionLabel.numberOfLines = 0
        view.addSubview(descriptionLabel)
    }
    
    private func setupActions() {
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    @objc private func startButtonTapped() {
        // 创建 VIPER 组件
        let userInteractor = VIPERUserInteractor()
        let navigationController = UINavigationController()
        let userRouter = VIPERUserRouter(navigationController: navigationController)
        let userPresenter = VIPERUserPresenter(interactor: userInteractor, router: userRouter)
        let userViewController = VIPERUserViewController(presenter: userPresenter)
        
        // 设置 presenter 的 view
        userPresenter.view = userViewController
        
        // 推送用户列表页面
        navigationController.setViewControllers([userViewController], animated: false)
        present(navigationController, animated: true, completion: nil)
    }
}
