//
//  UserDetailViewController.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

import UIKit

/// 用户详情页面视图控制器
class UserDetailViewController: UIViewController {
    /// 协调器
    weak var coordinator: MainCoordinator?
    
    /// 用户ID
    private let userId: Int
    
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private let idLabel = UILabel()
    
    /// 初始化方法
    /// - Parameter userId: 用户ID
    init(userId: Int) {
        self.userId = userId
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
        loadUserData()
    }
    
    private func setupUI() {
        // Setup id label
        idLabel.frame = CGRect(x: 50, y: 100, width: view.frame.width - 100, height: 30)
        idLabel.textAlignment = .center
        idLabel.font = UIFont.systemFont(ofSize: 16)
        idLabel.textColor = .gray
        view.addSubview(idLabel)
        
        // Setup name label
        nameLabel.frame = CGRect(x: 50, y: 150, width: view.frame.width - 100, height: 40)
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        nameLabel.textColor = .black
        view.addSubview(nameLabel)
        
        // Setup email label
        emailLabel.frame = CGRect(x: 50, y: 200, width: view.frame.width - 100, height: 30)
        emailLabel.textAlignment = .center
        emailLabel.font = UIFont.systemFont(ofSize: 18)
        emailLabel.textColor = .blue
        view.addSubview(emailLabel)
    }
    
    private func loadUserData() {
        // 模拟从API加载用户数据
        let user = mockUserById(userId)
        idLabel.text = "User ID: \(user.id)"
        nameLabel.text = user.name
        emailLabel.text = user.email
    }
    
    /// 根据ID获取模拟用户数据
    /// - Parameter id: 用户ID
    /// - Returns: 用户对象
    private func mockUserById(_ id: Int) -> CoordinatorUser {
        let users = [
            CoordinatorUser(id: 1, name: "Alice", email: "alice@example.com"),
            CoordinatorUser(id: 2, name: "Bob", email: "bob@example.com"),
            CoordinatorUser(id: 3, name: "Charlie", email: "charlie@example.com"),
            CoordinatorUser(id: 4, name: "David", email: "david@example.com"),
            CoordinatorUser(id: 5, name: "Eve", email: "eve@example.com")
        ]
        
        return users.first { $0.id == id } ?? CoordinatorUser(id: 0, name: "Unknown", email: "unknown@example.com")
    }
}
