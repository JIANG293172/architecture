//
//  UserDetailPresenter.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

/// 用户详情展示器，负责处理用户详情的业务逻辑和数据转换
class MVPUserDetailPresenter {
    weak var view: MVPUserDetailViewProtocol?
    private let userDataService: MVPUserDataService
    private let userID: Int
    
    init(userDataService: MVPUserDataService, userID: Int) {
        self.userDataService = userDataService
        self.userID = userID
    }
    
    /// 加载用户详情
    func loadUserDetails() {
        view?.showLoading()
        
        userDataService.fetchUserDetails(id: userID) { [weak self] user in
            self?.view?.hideLoading()
            if let user = user {
                self?.view?.displayUserDetail(user)
            } else {
                self?.view?.displayError("User not found")
            }
        }
    }
    
    /// 处理返回按钮点击
    func didTapBack() {
        view?.navigateBack()
    }
}
