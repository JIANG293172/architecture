//
//  MainCoordinator.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

import UIKit

/// 主协调器，管理应用的主流程导航
class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    /// 初始化方法
    /// - Parameter navigationController: 导航控制器
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    /// 启动协调器
    func start() {
        showWelcomeViewController()
    }
    
    /// 显示欢迎页面
    private func showWelcomeViewController() {
        let welcomeVC = WelcomeViewController()
        welcomeVC.coordinator = self
        navigationController.pushViewController(welcomeVC, animated: true)
    }
    
    /// 显示用户列表页面
    func showUserListViewController() {
        let userListVC = UserListViewController()
        userListVC.coordinator = self
        navigationController.pushViewController(userListVC, animated: true)
    }
    
    /// 显示用户详情页面
    /// - Parameter userId: 用户ID
    func showUserDetailViewController(userId: Int) {
        let userDetailVC = UserDetailViewController(userId: userId)
        userDetailVC.coordinator = self
        navigationController.pushViewController(userDetailVC, animated: true)
    }
    
    /// 显示设置页面
    func showSettingsViewController() {
        let settingsVC = SettingsViewController()
        settingsVC.coordinator = self
        navigationController.pushViewController(settingsVC, animated: true)
    }
}
