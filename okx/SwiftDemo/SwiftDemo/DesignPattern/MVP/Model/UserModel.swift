//
//  UserModel.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

/// 用户模型类，包含用户数据
class UserModel {
    let id: Int
    let name: String
    let email: String
    let age: Int
    
    init(id: Int, name: String, email: String, age: Int) {
        self.id = id
        self.name = name
        self.email = email
        self.age = age
    }
}

/// 用户数据服务，负责获取用户数据
class UserDataService {
    /// 获取用户列表
    /// - Parameter completion: 回调，返回用户模型数组
    func fetchUsers(completion: @escaping ([UserModel]) -> Void) {
        // 模拟网络请求获取用户数据
        DispatchQueue.global().async {
            // 模拟网络延迟
            sleep(1)
            
            // 模拟用户数据
            let users: [UserModel] = [
                UserModel(id: 1, name: "Alice", email: "alice@example.com", age: 25),
                UserModel(id: 2, name: "Bob", email: "bob@example.com", age: 30),
                UserModel(id: 3, name: "Charlie", email: "charlie@example.com", age: 35),
                UserModel(id: 4, name: "David", email: "david@example.com", age: 28),
                UserModel(id: 5, name: "Eve", email: "eve@example.com", age: 32)
            ]
            
            // 回到主线程回调
            DispatchQueue.main.async {
                completion(users)
            }
        }
    }
    
    /// 根据ID获取用户详情
    /// - Parameters:
    ///   - id: 用户ID
    ///   - completion: 回调，返回用户模型
    func fetchUserDetails(id: Int, completion: @escaping (UserModel?) -> Void) {
        // 模拟网络请求获取用户详情
        DispatchQueue.global().async {
            // 模拟网络延迟
            sleep(1)
            
            // 模拟用户数据
            let users: [UserModel] = [
                UserModel(id: 1, name: "Alice", email: "alice@example.com", age: 25),
                UserModel(id: 2, name: "Bob", email: "bob@example.com", age: 30),
                UserModel(id: 3, name: "Charlie", email: "charlie@example.com", age: 35),
                UserModel(id: 4, name: "David", email: "david@example.com", age: 28),
                UserModel(id: 5, name: "Eve", email: "eve@example.com", age: 32)
            ]
            
            // 查找指定ID的用户
            let user = users.first { $0.id == id }
            
            // 回到主线程回调
            DispatchQueue.main.async {
                completion(user)
            }
        }
    }
}
