//
//  User.swift
//  RxSwift02
//
//  Created by CQCA202121101_2 on 2025/11/11.
//

import Foundation

struct User {
    let id: Int
    let username: String
    let email: String
    let token: String
}

struct LoginRequest {
    let username: String
    let password: String
}

struct loginResponse {
    let user: User
    let message: String
}
