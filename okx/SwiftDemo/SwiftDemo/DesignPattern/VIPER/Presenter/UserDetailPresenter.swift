//
//  UserDetailPresenter.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

/// 用户详情展示器，作为 View 和 Interactor 之间的中介
class UserDetailPresenter {
    weak var view: UserDetailViewProtocol?
    private let interactor: UserDetailInteractor
    private let router: UserDetailRouter
    private let userID: Int
    
    init(interactor: UserDetailInteractor, router: UserDetailRouter, userID: Int) {
        self.interactor = interactor
        self.router = router
        self.userID = userID
    }
    
    /// 加载用户详情
    func loadUserDetails() {
        view?.showLoading()
        
        interactor.fetchUserDetails(id: userID) { [weak self] user in
            self?.view?.hideLoading()
            if let user = user {
                self?.view?.displayUserDetail(UserDetailViewModel(user: user))
            } else {
                self?.view?.displayError("User not found")
            }
        }
    }
    
    /// 处理返回按钮点击
    func didTapBack() {
        router.navigateBack()
    }
}

/// 用户详情视图协议，定义了 View 需要实现的方法
protocol UserDetailViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func displayUserDetail(_ user: UserDetailViewModel)
    func displayError(_ message: String)
}

/// 用户详情视图模型，用于在 Presenter 和 View 之间传递数据
struct UserDetailViewModel {
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
