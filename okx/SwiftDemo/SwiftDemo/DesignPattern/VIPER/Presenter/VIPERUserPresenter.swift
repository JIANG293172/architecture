//
//  UserPresenter.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

/// 用户展示器，作为 View 和 Interactor 之间的中介
class VIPERUserPresenter {
    weak var view: VIPERUserViewProtocol?
    private let interactor: VIPERUserInteractor
    private let router: VIPERUserRouter
    
    init(interactor: VIPERUserInteractor, router: VIPERUserRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    /// 加载用户列表
    func loadUsers() {
        view?.showLoading()
        
        interactor.fetchUsers { [weak self] users in
            self?.view?.hideLoading()
            self?.view?.displayUsers(users.map { VIPERUserViewModel(user: $0) })
        }
    }
    
    /// 处理用户选择
    /// - Parameter userViewModel: 选中的用户视图模型
    func didSelectUser(userViewModel: VIPERUserViewModel) {
        router.navigateToUserDetail(userID: userViewModel.id)
    }
}

/// 用户视图协议，定义了 View 需要实现的方法
protocol VIPERUserViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func displayUsers(_ users: [VIPERUserViewModel])
}

/// 用户视图模型，用于在 Presenter 和 View 之间传递数据
struct VIPERUserViewModel {
    let id: Int
    let name: String
    let email: String
    let age: Int
    
    init(user: UserEntity) {
        self.id = user.id
        self.name = user.name
        self.email = user.email
        self.age = user.age
    }
}
