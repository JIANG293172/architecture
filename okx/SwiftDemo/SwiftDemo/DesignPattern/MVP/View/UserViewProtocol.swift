//
//  UserViewProtocol.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

/// 用户视图协议，定义了 View 需要实现的方法
protocol UserViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func displayUsers(_ users: [UserViewModel])
    func navigateToUserDetail(user: UserModel)
}

/// 用户详情视图协议，定义了 View 需要实现的方法
protocol UserDetailViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func displayUserDetail(_ user: UserModel)
    func displayError(_ message: String)
    func navigateBack()
}

/// 用户视图模型，用于在 Presenter 和 View 之间传递数据
struct UserViewModel {
    let id: Int
    let name: String
    let email: String
    let age: Int
    
    init(user: UserModel) {
        self.id = user.id
        self.name = user.name
        self.email = user.email
        self.age = user.age
    }
}
