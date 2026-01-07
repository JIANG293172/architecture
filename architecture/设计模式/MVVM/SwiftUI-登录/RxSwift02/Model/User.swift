//
//  User.swift
//  RxSwift02
//
//  Created by CQCA202121101_2 on 2025/11/17.
//

import SwiftUI

// 用户模型
struct User: Identifiable {
    let id = UUID()
    let username: String
    let email: String
}

// 验证状态
enum ValidationState {
    case normal, valid, invalid
    
    var color: Color {
        switch self {
        case .normal: return .gray.opacity(0.5)
        case .valid: return .green
        case .invalid: return .red
        }
    }
    
    var icon: String {
        switch self {
        case .normal: return "circle"
        case .valid: return "checkmark.circle.fill"
        case .invalid: return "xmark.circle.fill"
        }
    }
    
    var iconColor: Color {
        switch self {
        case .normal: return .gray
        case .valid: return .green
        case .invalid: return .red
        }
    }
}

// 登录状态
enum LoginStatus {
    case idle, loading, success, failure(String)
}
