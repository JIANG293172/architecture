//
//  UserPresenter.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

/// 用户展示器，负责处理用户列表的业务逻辑和数据转换
class UserPresenter {
    weak var view: UserViewProtocol?
    private let userDataService: UserDataService
    
    init(userDataService: UserDataService) {
        self.userDataService = userDataService
    }
    
    /// 加载用户列表
    func loadUsers() {
        view?.showLoading()
        
        userDataService.fetchUsers { [weak self] users in
            self?.view?.hideLoading()
            self?.view?.displayUsers(users.map { UserViewModel(user: $0) })
        }
    }
    
    /// 处理用户选择
    /// - Parameter userViewModel: 选中的用户视图模型
    func didSelectUser(userViewModel: UserViewModel) {
        // 创建用户模型
        let user = UserModel(id: userViewModel.id, name: userViewModel.name, email: userViewModel.email, age: userViewModel.age)
        view?.navigateToUserDetail(user: user)
    }
}
