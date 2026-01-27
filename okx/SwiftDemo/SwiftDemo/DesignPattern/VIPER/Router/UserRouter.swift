//
//  UserRouter.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

import UIKit

/// 用户路由器，负责导航逻辑
class UserRouter {
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    /// 导航到用户详情页
    /// - Parameter userID: 用户ID
    func navigateToUserDetail(userID: Int) {
        // 创建用户详情页的 VIPER 组件
        let userDetailInteractor = UserDetailInteractor()
        let userDetailRouter = UserDetailRouter(navigationController: navigationController)
        let userDetailPresenter = UserDetailPresenter(interactor: userDetailInteractor, router: userDetailRouter, userID: userID)
        let userDetailViewController = UserDetailViewController(presenter: userDetailPresenter)
        
        // 设置 presenter 的 view
        userDetailPresenter.view = userDetailViewController
        
        // 导航到用户详情页
        navigationController?.pushViewController(userDetailViewController, animated: true)
    }
}

/// 用户详情路由器，负责导航逻辑
class UserDetailRouter {
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    /// 导航回上一页
    func navigateBack() {
        navigationController?.popViewController(animated: true)
    }
}
