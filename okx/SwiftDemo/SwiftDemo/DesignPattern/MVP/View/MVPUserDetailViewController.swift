//
//  UserDetailViewController.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

import UIKit

/// 用户详情视图控制器，实现了 MVPUserDetailViewProtocol 协议
class MVPUserDetailViewController: UIViewController, MVPUserDetailViewProtocol {
    private let presenter: MVPUserDetailPresenter
    private let stackView = UIStackView()
    private let idLabel = UILabel()
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private let ageLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    init(presenter: MVPUserDetailPresenter) {
        self.presenter = presenter
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
        
        // 设置 presenter 的 view
        presenter.view = self
        
        // 加载用户详情
        presenter.loadUserDetails()
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
    
    @objc private func backButtonTapped() {
        presenter.didTapBack()
    }
    
    // MARK: - UserDetailViewProtocol
    
    func showLoading() {
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
    }
    
    func displayUserDetail(_ user: MVPUserModel) {
        idLabel.text = "ID: \(user.id)"
        nameLabel.text = user.name
        emailLabel.text = "Email: \(user.email)"
        ageLabel.text = "Age: \(user.age) years old"
    }
    
    func displayError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func navigateBack() {
        navigationController?.popViewController(animated: true)
    }
}
