//
//  MVPUserViewProtocol.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

/// 用户视图协议，定义了 View 需要实现的方法
protocol MVPUserViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func displayUsers(_ users: [MVPUserModel])
    func navigateToUserDetail(_ user: MVPUserModel)
}

/// 用户详情视图协议，定义了 View 需要实现的方法
protocol MVPUserDetailViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func displayUserDetail(_ user: MVPUserModel)
    func displayError(_ message: String)
    func navigateBack()
}

/// 用户视图模型，用于在 Presenter 和 View 之间传递数据
struct MVPUserViewModel {
    let id: Int
    let name: String
    let email: String
    let age: Int
    
    init(user: MVPUserModel) {
        self.id = user.id
        self.name = user.name
        self.email = user.email
        self.age = user.age
    }
}
