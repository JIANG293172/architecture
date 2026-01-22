//
//  LoginTextField.swift
//  RxSwift02
//
//  Created by CQCA202121101_2 on 2025/11/17.
//

import SwiftUI

// 登录输入框
struct LoginTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var validationState: ValidationState = .normal
    var onSubmit: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .fontWeight(.medium)
            
            HStack {
                if isSecure {
                    SecureField(placeholder, text: $text)
                        .textFieldStyle(PlainTextFieldStyle())
                } else {
                    TextField(placeholder, text: $text)
                        .textFieldStyle(PlainTextFieldStyle())
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                }
                
                Image(systemName: validationState.icon)
                    .foregroundColor(validationState.iconColor)
                    .font(.system(size: 16))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color(.systemBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(validationState.color, lineWidth: 1.5)
            )
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
    }
}

// 验证信息标签
struct ValidationLabel: View {
    let message: String
    let isValid: Bool
    
    var body: some View {
        HStack {
            Text(message)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(isValid ? .green : .red)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
        .padding(.horizontal, 4)
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
    }
}

// 加载按钮
struct LoadingButton: View {
    let title: String
    let isLoading: Bool
    let isEnabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // 背景
                RoundedRectangle(cornerRadius: 12)
                    .fill(backgroundColor)
                    .frame(height: 50)
                    .shadow(color: .blue.opacity(isEnabled ? 0.3 : 0), radius: 8, x: 0, y: 4)
                
                // 内容
                HStack(spacing: 12) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.9)
                    }
                    
                    Text(title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
        }
        .disabled(!isEnabled || isLoading)
        .scaleEffect(isLoading ? 0.98 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isLoading)
        .animation(.easeInOut(duration: 0.2), value: isEnabled)
    }
    
    private var backgroundColor: Color {
        if !isEnabled {
            return .gray
        } else if isLoading {
            return .blue.opacity(0.7)
        } else {
            return .blue
        }
    }
}

// 记住我按钮
struct RememberMeButton: View {
    @Binding var isOn: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: isOn ? "checkmark.square.fill" : "square")
                    .font(.system(size: 20))
                    .foregroundColor(isOn ? .blue : .gray)
                
                Text("记住我")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                
                Spacer()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}
