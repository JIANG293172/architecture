//
//  UserDetailViewModel.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

import Foundation
import Combine

/// 用户详情视图模型，负责处理用户详情的业务逻辑和数据转换
class MVVMUserDetailViewModel: ObservableObject {
    @Published var user: MVVMUserModel? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let userDataService: MVVMUserDataService
    private let userID: Int
    private var cancellables = Set<AnyCancellable>()
    
    init(userDataService: MVVMUserDataService, userID: Int) {
        self.userDataService = userDataService
        self.userID = userID
    }
    
    /// 加载用户详情
    func loadUserDetails() {
        isLoading = true
        errorMessage = nil
        
        userDataService.fetchUserDetails(id: userID) { [weak self] user in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let user = user {
                    self?.user = user
                } else {
                    self?.errorMessage = "User not found"
                }
            }
        }
    }
}
