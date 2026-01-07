//
//  LoginViewModel.swift
//  CombineLoginDemo
//

import Foundation
import Combine

class LoginViewModel {
    struct Input {
        let username: AnyPublisher<String, Never>
        let password: AnyPublisher<String, Never>
        let loginTapped: AnyPublisher<Void, Never>
        let rememberMeChanged: AnyPublisher<Bool, Never>
    }
    
    struct Output {
        let usernameValidation: AnyPublisher<ValidationResult, Never>
        let passwordValidation: AnyPublisher<ValidationResult, Never>
        let loginButtonEnabled: AnyPublisher<Bool, Never>
        let isLoading: AnyPublisher<Bool, Never>
        let loginResult: AnyPublisher<LoginResult, Never>
        let rememberMeState: AnyPublisher<Bool, Never>
    }
    
    enum LoginResult {
        case success(User)
        case failure(String)
        case none
    }
    
    private let authService: AuthServiceType
    private let userDefaults = UserDefaults.standard
    private var cancellables = Set<AnyCancellable>()
    
    init(authService: AuthServiceType = AuthService.shared) {
        self.authService = authService
    }
    
    func transform(input: Input) -> Output {
        // 用户名验证
        let usernameValidation = input.username
            .dropFirst()
            .removeDuplicates()
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .map { [weak self] username in
                try? self?.authService.validateUsername(username) ?? ValidationResult(isValid: false, message: "验证失败")
            }
            .compactMap { $0 }
            .eraseToAnyPublisher()
        
        // 密码验证
        let passwordValidation = input.password
            .dropFirst()
            .removeDuplicates()
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .map { [weak self] password in
                self?.authService.validatePassword(password) ?? ValidationResult(isValid: false, message: "验证失败")
            }
            .eraseToAnyPublisher()
        
        // 表单验证
        let formValidation = Publishers.CombineLatest(
            usernameValidation,
            passwordValidation
        )
        .map { usernameValid, passwordValid in
            return usernameValid.isValid && passwordValid.isValid
        }
        .removeDuplicates()
        .eraseToAnyPublisher()
        
        // 加载状态追踪器
        let loadingSubject = PassthroughSubject<Bool, Never>()
        
        // 登录按钮状态
        let loginButtonEnabled = Publishers.CombineLatest(
            formValidation,
            loadingSubject
        )
        .map { formValid, isLoading in
            return formValid && !isLoading
        }
        .eraseToAnyPublisher()
        
        // 登录凭证 - 使用 CurrentValueSubject 来保存最新值
        let loginCredentialsSubject = CurrentValueSubject<(String, String), Never>(("", ""))
        
        // 更新登录凭证
        Publishers.CombineLatest(input.username, input.password)
            .sink { credentials in
                loginCredentialsSubject.send(credentials)
            }
            .store(in: &cancellables)
        
        // 登录结果 - 使用 combineLatest 替代 withLatestFrom
        let loginResult = input.loginTapped
            .combineLatest(loginCredentialsSubject)
            .map { $0.1 } // 取 credentials，忽略 tap 事件本身
            .flatMap { [weak self] (username, password) -> AnyPublisher<LoginResult, Never> in
                guard let self = self else {
                    return Just(.failure("系统错误")).eraseToAnyPublisher()
                }
                
                loadingSubject.send(true)
                
                return self.authService.login(username: username, password: password)
                    .map { response in
                        loadingSubject.send(false)
                        return .success(response.user)
                    }
                    .catch { error in
                        loadingSubject.send(false)
                        let errorMessage = error.localizedDescription
                        return Just(LoginResult.failure(errorMessage))
                    }
                    .eraseToAnyPublisher()
            }
            .prepend(.none)
            .eraseToAnyPublisher()
        
        // 记住我状态
        let rememberMeState = input.rememberMeChanged
            .prepend(userDefaults.bool(forKey: "rememberMe"))
            .removeDuplicates()
            .handleEvents(receiveOutput: { [weak self] isOn in
                self?.userDefaults.set(isOn, forKey: "rememberMe")
                let username = loginCredentialsSubject.value.0
                if isOn, !username.isEmpty {
                    self?.userDefaults.set(username, forKey: "savedUsername")
                }
            })
            .eraseToAnyPublisher()
        
        // 如果记住我开启，恢复用户名
        if userDefaults.bool(forKey: "rememberMe"),
           let savedUsername = userDefaults.string(forKey: "savedUsername") {
            // 可以通过其他方式通知设置用户名
            print("恢复用户名: \(savedUsername)")
        }
        
        return Output(
            usernameValidation: usernameValidation,
            passwordValidation: passwordValidation,
            loginButtonEnabled: loginButtonEnabled,
            isLoading: loadingSubject.eraseToAnyPublisher(),
            loginResult: loginResult,
            rememberMeState: rememberMeState
        )
    }
}
