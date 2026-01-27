//
//  UserListViewController.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

import UIKit

/// 用户模型
struct CoordinatorUser {
    let id: Int
    let name: String
    let email: String
}

/// 用户列表页面视图控制器
class UserListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    /// 协调器
    weak var coordinator: MainCoordinator?
    
    private let tableView = UITableView()
    private let users = [
        CoordinatorUser(id: 1, name: "Alice", email: "alice@example.com"),
        CoordinatorUser(id: 2, name: "Bob", email: "bob@example.com"),
        CoordinatorUser(id: 3, name: "Charlie", email: "charlie@example.com"),
        CoordinatorUser(id: 4, name: "David", email: "david@example.com"),
        CoordinatorUser(id: 5, name: "Eve", email: "eve@example.com")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "User List"
        view.backgroundColor = .white
        setupUI()
        setupTableView()
    }
    
    private func setupUI() {
        // Setup right bar button item
        let settingsButton = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsButtonTapped))
        navigationItem.rightBarButtonItem = settingsButton
    }
    
    private func setupTableView() {
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UserCell")
        view.addSubview(tableView)
    }
    
    @objc private func settingsButtonTapped() {
        coordinator?.showSettingsViewController()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = users[indexPath.row]
        coordinator?.showUserDetailViewController(userId: user.id)
    }
}


