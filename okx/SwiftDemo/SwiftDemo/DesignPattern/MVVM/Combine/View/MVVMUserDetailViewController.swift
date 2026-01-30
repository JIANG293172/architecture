//
//  UserDetailViewController.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

import UIKit
import Combine

/// 用户详情视图控制器，使用 MVVM 架构
class MVVMUserDetailViewController: UIViewController {
    private let viewModel: MVVMUserDetailViewModel
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let stackView = UIStackView()
    private let idLabel = UILabel()
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private let ageLabel = UILabel()
    private let backButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: MVVMUserDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "User Detail"
        view.backgroundColor = .white
        setupUI()
        setupActivityIndicator()
        bindViewModel()
        
        // 加载用户详情
        viewModel.loadUserDetails()
    }
    
    private func setupUI() {
        // 设置返回按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        
        // 设置堆栈视图
        stackView.frame = CGRect(x: 50, y: 100, width: view.frame.width - 100, height: 200)
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .leading
        view.addSubview(stackView)
        
        // 设置标签
        setupLabels()
    }
    
    private func setupLabels() {
        // 设置ID标签
        idLabel.font = UIFont.systemFont(ofSize: 16)
        idLabel.textColor = .black
        stackView.addArrangedSubview(idLabel)
        
        // 设置名称标签
        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        nameLabel.textColor = .black
        stackView.addArrangedSubview(nameLabel)
        
        // 设置邮箱标签
        emailLabel.font = UIFont.systemFont(ofSize: 16)
        emailLabel.textColor = .black
        stackView.addArrangedSubview(emailLabel)
        
        // 设置年龄标签
        ageLabel.font = UIFont.systemFont(ofSize: 16)
        ageLabel.textColor = .black
        stackView.addArrangedSubview(ageLabel)
    }
    
    private func setupActivityIndicator() {
        activityIndicator.center = view.center
        activityIndicator.color = .blue
        view.addSubview(activityIndicator)
    }
    
    private func bindViewModel() {
        // 绑定用户详情数据
        viewModel.$user
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                if let user = user {
                    self?.idLabel.text = "ID: \(user.id)"
                    self?.nameLabel.text = user.name
                    self?.emailLabel.text = "Email: \(user.email)"
                    self?.ageLabel.text = "Age: \(user.age) years old"
                }
            }
            .store(in: &cancellables)
        
        // 绑定加载状态
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
        
        // 绑定错误消息
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                if let errorMessage = errorMessage {
                    let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
            .store(in: &cancellables)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
