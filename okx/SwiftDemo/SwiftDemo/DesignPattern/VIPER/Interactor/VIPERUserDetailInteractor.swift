//
//  UserDetailInteractor.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

import Foundation

/// 用户详情交互器，负责用户详情的业务逻辑和数据获取
class VIPERUserDetailInteractor {
    /// 根据ID获取用户详情
    /// - Parameters:
    ///   - id: 用户ID
    ///   - completion: 回调，返回用户实体
    func fetchUserDetails(id: Int, completion: @escaping (UserEntity?) -> Void) {
        // 模拟网络请求获取用户详情
        DispatchQueue.global().async {
            // 模拟网络延迟
            sleep(1)
            
            // 模拟用户数据
            let users: [UserEntity] = [
                UserEntity(id: 1, name: "Alice", email: "alice@example.com", age: 25),
                UserEntity(id: 2, name: "Bob", email: "bob@example.com", age: 30),
                UserEntity(id: 3, name: "Charlie", email: "charlie@example.com", age: 35),
                UserEntity(id: 4, name: "David", email: "david@example.com", age: 28),
                UserEntity(id: 5, name: "Eve", email: "eve@example.com", age: 32)
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
