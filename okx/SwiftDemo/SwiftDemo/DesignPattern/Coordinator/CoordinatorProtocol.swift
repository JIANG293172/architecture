//
//  CoordinatorProtocol.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

import UIKit

/// Coordinator 协议，定义了协调器的基本方法
protocol Coordinator: AnyObject {
    /// 子协调器
    var childCoordinators: [Coordinator] {
        get set
    }
    
    /// 导航控制器
    var navigationController: UINavigationController {
        get set
    }
    
    /// 启动协调器
    func start()
    
    /// 添加子协调器
    func addChildCoordinator(_ coordinator: Coordinator)
    
    /// 移除子协调器
    func removeChildCoordinator(_ coordinator: Coordinator)
}

/// Coordinator 协议的默认实现
extension Coordinator {
    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}

/// TabBarCoordinator 协议，定义了标签栏协调器的方法
protocol TabBarCoordinator: Coordinator {
    /// 标签栏控制器
    var tabBarController: UITabBarController {
        get set
    }
    
    /// 启动标签栏协调器
    func startTabBar()
}
