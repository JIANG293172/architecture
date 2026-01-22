//
//  LoginView.swift
//  RxSwift02
//
//  Created by CQCA202121101_2 on 2025/11/17.
//

import SwiftUI

struct LoginView: View {
    // MARK: - 状态管理
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var rememberMe: Bool = false
    @State private var loginStatus: LoginStatus = .idle
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    // 验证状态
    @State private var usernameValidationState: ValidationState = .normal
    @State private var passwordValidationState: ValidationState = .normal
    @State private var usernameValidationMessage: String = ""
    @State private var passwordValidationMessage: String = ""
    
    // 焦点管理
    @FocusState private var focusedField: Field?
    
    enum Field {
        case username, password
    }
    
    // MARK: - 计算属性
    private var isLoginButtonEnabled: Bool {
        !username.isEmpty &&
        !password.isEmpty &&
        usernameValidationState != .invalid &&
        passwordValidationState != .invalid &&
        !isLoading
    }
    
    private var isLoading: Bool {
        if case .loading = loginStatus {
            return true
        }
        return false
    }
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                // 背景
                backgroundView
                
                // 内容
                ScrollView {
                    VStack(spacing: 32) {
                        headerView
                        formView
                        actionButtons
                        footerLinks
                    }
                    .padding(.horizontal, 28)
                    .padding(.top, 60)
                    .padding(.bottom, 40)
                }
            }
            .navigationBarHidden(true)
            .alert("登录结果", isPresented: $showAlert) {
                Button("确定", role: .cancel) {
                    resetLoginStatus()
                }
            } message: {
                Text(alertMessage)
            }
            .onAppear {
                loadRememberedCredentials()
            }
        }
    }
    
    // MARK: - 子视图
    
    private var backgroundView: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.blue.opacity(0.08),
                Color.purple.opacity(0.06),
                Color.blue.opacity(0.04)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            // Logo
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [.blue, .purple]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 100, height: 100)
                    .shadow(color: .blue.opacity(0.3), radius: 12, x: 0, y: 6)
                
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.white)
            }
            
            // 标题
            VStack(spacing: 8) {
                Text("欢迎回来")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("请登录您的账户继续使用")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var formView: some View {
        VStack(spacing: 20) {
            // 用户名输入
            VStack(alignment: .leading, spacing: 6) {
                LoginTextField(
                    title: "用户名/邮箱",
                    placeholder: "请输入您的用户名或邮箱",
                    text: $username,
                    validationState: usernameValidationState
                )
                .focused($focusedField, equals: .username)
                .onChange(of: username) { _ in
                    validateUsername()
                }
                .submitLabel(.next)
                .onSubmit {
                    focusedField = .password
                }
                
                if !usernameValidationMessage.isEmpty {
                    ValidationLabel(
                        message: usernameValidationMessage,
                        isValid: usernameValidationState == .valid
                    )
                }
            }
            
            // 密码输入
            VStack(alignment: .leading, spacing: 6) {
                LoginTextField(
                    title: "密码",
                    placeholder: "请输入您的密码",
                    text: $password,
                    isSecure: true,
                    validationState: passwordValidationState
                )
                .focused($focusedField, equals: .password)
                .onChange(of: password) { _ in
                    validatePassword()
                }
                .submitLabel(.go)
                .onSubmit {
                    if isLoginButtonEnabled {
                        login()
                    }
                }
                
                if !passwordValidationMessage.isEmpty {
                    ValidationLabel(
                        message: passwordValidationMessage,
                        isValid: passwordValidationState == .valid
                    )
                }
            }
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 20) {
            // 记住我
            RememberMeButton(isOn: $rememberMe) {
                rememberMe.toggle()
                handleRememberMeToggle()
            }
            
            // 登录按钮
            LoadingButton(
                title: "登录",
                isLoading: isLoading,
                isEnabled: isLoginButtonEnabled
            ) {
                // 收起键盘
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                login()
            }
        }
    }
    
    private var footerLinks: some View {
        HStack(spacing: 30) {
            Button("忘记密码?") {
                showForgotPasswordAlert()
            }
            .foregroundColor(.blue)
            .font(.system(size: 15, weight: .medium))
            
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 1, height: 16)
            
            NavigationLink("注册新账户") {
                RegisterView()
            }
            .foregroundColor(.blue)
            .font(.system(size: 15, weight: .medium))
        }
    }
    
    // MARK: - 业务逻辑
    
    private func validateUsername() {
        if username.isEmpty {
            usernameValidationState = .normal
            usernameValidationMessage = ""
            return
        }
        
        // 简单验证：可以是邮箱或普通用户名
        if username.count < 3 {
            usernameValidationState = .invalid
            usernameValidationMessage = "用户名至少需要3个字符"
            return
        }
        
        // 如果是邮箱格式，验证邮箱
        if username.contains("@") {
            let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
            let isValidEmail = username.range(of: emailRegex, options: .regularExpression) != nil
            if !isValidEmail {
                usernameValidationState = .invalid
                usernameValidationMessage = "请输入有效的邮箱地址"
                return
            }
        }
        
        usernameValidationState = .valid
        usernameValidationMessage = "用户名格式正确"
    }
    
    private func validatePassword() {
        if password.isEmpty {
            passwordValidationState = .normal
            passwordValidationMessage = ""
            return
        }
        
        if password.count < 6 {
            passwordValidationState = .invalid
            passwordValidationMessage = "密码至少需要6个字符"
            return
        }
        
        passwordValidationState = .valid
        passwordValidationMessage = "密码格式正确"
    }
    
    private func login() {
        guard !isLoading && isLoginButtonEnabled else { return }
        
        loginStatus = .loading
        
        // 模拟网络请求
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // 模拟登录逻辑
            let isValidCredentials = (self.username == "admin@example.com" || self.username == "user123") &&
                                   self.password == "123456"
            
            if isValidCredentials {
                self.loginStatus = .success
                self.showSuccessAlert()
                self.saveCredentialsIfNeeded()
            } else {
                self.loginStatus = .failure("用户名或密码错误")
                self.showErrorAlert(message: "用户名或密码错误，请重试")
            }
        }
    }
    
    private func showSuccessAlert() {
        alertMessage = "登录成功！欢迎回来。"
        showAlert = true
    }
    
    private func showErrorAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
    
    private func showForgotPasswordAlert() {
        alertMessage = "请联系系统管理员或使用注册邮箱重置密码。"
        showAlert = true
    }
    
    private func resetLoginStatus() {
        if case .success = loginStatus {
            // 登录成功后的处理，比如跳转到主页
            username = ""
            password = ""
            usernameValidationState = .normal
            passwordValidationState = .normal
            usernameValidationMessage = ""
            passwordValidationMessage = ""
        }
        loginStatus = .idle
    }
    
    // MARK: - 本地存储
    
    private func saveCredentialsIfNeeded() {
        if rememberMe {
            UserDefaults.standard.set(username, forKey: "savedUsername")
            UserDefaults.standard.set(password, forKey: "savedPassword")
        }
    }
    
    private func loadRememberedCredentials() {
        let rememberMe = UserDefaults.standard.bool(forKey: "rememberMe")
        self.rememberMe = rememberMe
        
        if rememberMe {
            if let savedUsername = UserDefaults.standard.string(forKey: "savedUsername") {
                self.username = savedUsername
                validateUsername()
            }
            if let savedPassword = UserDefaults.standard.string(forKey: "savedPassword") {
                self.password = savedPassword
                validatePassword()
            }
        }
    }
    
    private func handleRememberMeToggle() {
        UserDefaults.standard.set(rememberMe, forKey: "rememberMe")
        if !rememberMe {
            // 如果取消记住我，清除保存的凭证
            UserDefaults.standard.removeObject(forKey: "savedUsername")
            UserDefaults.standard.removeObject(forKey: "savedPassword")
        }
    }
}
