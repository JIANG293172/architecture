import Foundation
import RxSwift
import RxCocoa

/// RxSwift 版本的登录视图模型
class RxMVVMLoginViewModel {
    
    // MARK: - Inputs
    let username = BehaviorRelay<String>(value: "") /// 这个类似于Combine里面的publisher，或则是 passthroughSubject，他们都是发布者
    let password = BehaviorRelay<String>(value: "") /// 发布者
    let loginTapped = PublishRelay<Void>() /// 发布者
    
    // MARK: - Outputs
    let isLoading = BehaviorRelay<Bool>(value: false)
    let loginResult = PublishRelay<Result<RxMVVMLoginUser, RxLoginError>>()
    
    
    let isLoginEnabled: Observable<Bool>
    let errorMessage: Observable<String?>
    
    private let disposeBag = DisposeBag()
    
    init() {
        // 1. 处理登录按钮是否可用 (类似 Combine 的 combineLatest)
        isLoginEnabled = Observable.combineLatest(username, password)
            .map { username, password in
                return username.count >= 3 && password.count >= 6
            }
            .distinctUntilChanged()
            
        // 2. 处理错误消息输出 (先初始化所有 let 属性，避免 self 被捕获时属性未完全初始化)
        errorMessage = loginResult
            .map { result -> String? in
                if case .failure(let error) = result {
                    return error.localizedDescription
                }
                return nil
            }
            
        // 3. 处理登录点击事件 (演示 flatMapLatest 处理异步请求)
        loginTapped
            .withLatestFrom(Observable.combineLatest(username, password))
            .do(onNext: { [weak self] _ in self?.isLoading.accept(true) })
            .flatMapLatest { [weak self] username, password -> Observable<Result<RxMVVMLoginUser, RxLoginError>> in
                return self?.performLogin(user: username, pass: password) ?? .empty()
            }
            .do(onNext: { [weak self] _ in self?.isLoading.accept(false) })
            .bind(to: loginResult)
            .disposed(by: disposeBag)
    }
    
    // 模拟登录请求
    private func performLogin(user: String, pass: String) -> Observable<Result<RxMVVMLoginUser, RxLoginError>> {
        return Observable.create { observer in
            // 模拟网络延迟
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
                if user == "admin" && pass == "123456" {
                    let mockUser = RxMVVMLoginUser(id: "rx_1", username: "RxSwift管理员", token: "rx_token_123", lastLogin: Date())
                    observer.onNext(.success(mockUser))
                } else {
                    observer.onNext(.failure(.invalidCredentials))
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    // MARK: - RxSwift 常用操作符演示方法
    func runCommonRxOperatorsDemo() {
        print("\n--- RxSwift Common Operators Demo ---")
        
        // 1. Filter
        Observable.of(1, 2, 3, 4, 5, 6)
            .filter { $0 % 2 == 0 }
            .subscribe(onNext: { print("Filter (even): \($0)") })
            .disposed(by: disposeBag)
            
        // 2. Take
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .take(3)
            .subscribe(onNext: { value in print("Take (interval): \(value)") })
            .disposed(by: disposeBag)
            
        // 3. Debounce (防抖)
        let searchSubject = PublishSubject<String>()
        searchSubject
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { print("Debounce (search): \($0)") })
            .disposed(by: disposeBag)
            
        searchSubject.onNext("A")
        searchSubject.onNext("Ap")
        searchSubject.onNext("App") // 只有这个会在 500ms 后输出
        
        // 4. Zip
        let s1 = Observable.just("Hello")
        let s2 = Observable.just("RxSwift")
        Observable.zip(s1, s2)
            .map { "\($0) \($1)" }
            .subscribe(onNext: { print("Zip: \($0)") })
            .disposed(by: disposeBag)
    }
}
