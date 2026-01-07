//
//  LoginViewModel.swift
//  RxSwift02
//
//  Created by CQCA202121101_2 on 2025/11/11.
//

import Foundation
import RxCocoa
import RxSwift

class LoginViewModel {
    
    struct Input {
        let username: Observable<String>
        let password: Observable<String>
        let loginTapped: Observable<Void>
        let rememberMeChanged: Observable<Bool>
    }
    
    struct Output {
        let usernameValidation: Driver<ValidationResult>
        let passwordValidation: Driver<ValidationResult>
        let loginButtonEnabled: Driver<Bool>
        
        let isLoading: Driver<Bool>
        let loginResult: Driver<LoginResult>
        let rememberMeState: Driver<Bool>
    }
    
    enum LoginResult {
        case success(User)
        case failure(String)
        case none
    }
    
    private let authService: AuthServiceType
    private let userDefaults  = UserDefaults.standard
    private let disposeBag = DisposeBag()
    
    
    init(authService: AuthServiceType = AuthService.shared) {
           self.authService = authService
    }
    
    func transform(input: Input) -> Output {
        let loadingTracker =  ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        
        let usernameValidation = input.username
            .skip(1)
            .distinctUntilChanged()
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { [weak self] username in
                try self?.authService.validateUsername(username) ?? ValidationResult(isValid: false, message: "验证失败")
            }
            .asDriver(onErrorJustReturn: ValidationResult(isValid: false, message: "验证错误"))
        
        let passwordValidion = input.password
            .skip(1)
            .distinctUntilChanged()
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { [weak self] password in
                self?.authService.validatePassword(password) ?? ValidationResult(isValid: false, message: "验证失败")
            }
            .asDriver(onErrorJustReturn: ValidationResult(isValid: false, message: "验证错误"))
        
        
        let formValidation = Observable.combineLatest(
            usernameValidation.asObservable(),
            passwordValidion.asObservable()
        ).map { usernameValid, passwordValid in
            return usernameValid.isValid && passwordValid.isValid
            }.distinctUntilChanged()
        
        let loginButtonEnabled = Observable.combineLatest(
            formValidation,
            loadingTracker.asObservable()
        )
            .map { formValid, isLoding in
            return formValid && !isLoding
        }
            .asDriver(onErrorJustReturn: false)
        
        let loginCredentials = Observable.combineLatest(
            input.username,
            input.password
        )
        
        let loginResult = input.loginTapped
            .withLatestFrom(loginCredentials)
            .flatMapLatest { [weak self] username, password -> Observable<LoginResult> in
                guard let self = self else {
                    return .just(.failure("系统错误"))
                }
                return self.authService.login(username: username, password: password)
                    .trackActivity(loadingTracker)
                    .trackError(errorTracker)
                    .map { response in
                        return .success(response.user)
                    }
                    .catch { error in
                        let errorMessage = error.localizedDescription
                        return .just(.failure(errorMessage))
                    }
            }.startWith(.none)
            .asDriver(onErrorJustReturn: .failure("未知错误"))
        
        
        let rememberMeState = input.rememberMeChanged
            .startWith(userDefaults.bool(forKey: "rememberMe"))
            .distinctUntilChanged()
            .do(onNext: { [weak self] isOn in
                self?.userDefaults.set(isOn, forKey: "rememberMe")
            }).asDriver(onErrorJustReturn: false)
        
        if userDefaults.bool(forKey: "rememberMe"),
        let savedUserName = userDefaults.string(forKey: "savedUsername") {
            // 通知设置用户名
        }
        
        return Output(usernameValidation: usernameValidation, passwordValidation: passwordValidion, loginButtonEnabled: loginButtonEnabled, isLoading: loadingTracker.asDriver(), loginResult: loginResult, rememberMeState: rememberMeState)
        
    }
    
  
    
}
