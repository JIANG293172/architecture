//
//  UserPresenter.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

/// 用户展示器，负责处理用户列表的业务逻辑和数据转换
class MVPUserPresenter {
    weak var view: MVPUserViewProtocol?
    private let userDataService: MVPUserDataService
    
    init(userDataService: MVPUserDataService) {
        self.userDataService = userDataService
    }
    
    /// 加载用户列表
    func loadUsers() {
        view?.showLoading()
        
        userDataService.fetchUsers { [weak self] users in
            self?.view?.hideLoading()
            self?.view?.displayUsers(users)
        }
    }
    
    /// 处理用户选择
    /// - Parameter user: 选中的用户
    func didSelectUser(user: MVPUserModel) {
        view?.navigateToUserDetail(user)
    }
}
