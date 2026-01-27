//
//  UserViewController.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

import UIKit

/// 用户列表视图控制器，实现了 UserViewProtocol 协议
class UserViewController: UIViewController, UserViewProtocol {
    private let presenter: UserPresenter
    private let tableView = UITableView()
    private var users: [UserViewModel] = []
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    init(presenter: UserPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MVP Users"
        view.backgroundColor = .white
        setupUI()
        setupTableView()
        setupActivityIndicator()
        
        // 设置 presenter 的 view
        presenter.view = self
        
        // 加载用户列表
        presenter.loadUsers()
    }
    
    private func setupUI() {
        // 设置表格视图
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(tableView)
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UserCell")
    }
    
    private func setupActivityIndicator() {
        activityIndicator.center = view.center
        activityIndicator.color = .blue
        view.addSubview(activityIndicator)
    }
    
    // MARK: - UserViewProtocol
    
    func showLoading() {
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
    }
    
    func displayUsers(_ users: [UserViewModel]) {
        self.users = users
        tableView.reloadData()
    }
    
    func navigateToUserDetail(user: UserModel) {
        // 创建用户详情页的 MVP 组件
        let userDetailPresenter = UserDetailPresenter(userDataService: UserDataService(), userID: user.id)
        let userDetailViewController = UserDetailViewController(presenter: userDetailPresenter)
        
        // 设置 presenter 的 view
        userDetailPresenter.view = userDetailViewController
        
        // 导航到用户详情页
        navigationController?.pushViewController(userDetailViewController, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension UserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = "\(user.email) (\(user.age) years old)"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

// MARK: - UITableViewDelegate

extension UserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let userViewModel = users[indexPath.row]
        presenter.didSelectUser(userViewModel: userViewModel)
    }
}
