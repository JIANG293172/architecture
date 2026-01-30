//
//  UserViewModel.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

import Foundation
import Combine

/// 用户视图模型，负责处理用户列表的业务逻辑和数据转换
class MVVMUserViewModel: ObservableObject {
    @Published var users: [MVVMUserItemViewModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let userDataService: MVVMUserDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(userDataService: MVVMUserDataService) {
        self.userDataService = userDataService
    }
    
    /// 加载用户列表
    func loadUsers() {
        isLoading = true
        errorMessage = nil
        
        userDataService.fetchUsers { [weak self] users in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.users = users.map { MVVMUserItemViewModel(user: $0) }
            }
        }
    }
}

/// 用户项视图模型，用于在列表中显示单个用户
struct MVVMUserItemViewModel: Identifiable {
    let id: Int
    let name: String
    let email: String
    let age: Int
    
    init(user: MVVMUserModel) {
        self.id = user.id
        self.name = user.name
        self.email = user.email
        self.age = user.age
    }
}
