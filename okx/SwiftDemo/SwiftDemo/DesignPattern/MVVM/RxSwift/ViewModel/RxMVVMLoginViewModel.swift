import Foundation
import RxSwift
import RxCocoa
import Combine

final class RxMVVMLoginViewModel {
    
    let username = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")
    let loginTapped = PublishRelay<Void>()
    let registerTapped = PublishRelay<Void>()

    let isLoading = BehaviorRelay<Bool>(value: false)

    let isLoginEnabled: Driver<Bool>
    let errorMessage: Driver<String?>
    let loginSuccess: Signal<RxMVVMLoginUser>
    let routeToRegister: Signal<String>

    private let loginResult = PublishRelay<Result<RxMVVMLoginUser, RxLoginError>>()
    private let disposeBag = DisposeBag()
    private let authService: RxAuthServicing

    
    func rxSwiftBehaviorSuject() {
        print("===== BehaviorSubject（存值）=====")
        // 1. 创建：必须指定初始值（这是“存值”的第一个体现）
        let behaviorSubject = BehaviorSubject<String>(value: "初始值")

        // 2. 发送第一个值（更新内部存储的“当前值”）
        behaviorSubject.onNext("发送值1")

        // 3. 第一次订阅：订阅时立即收到“最新值（发送值1）”（存值的核心体现）
        behaviorSubject.subscribe(onNext: { value in
            print("订阅者1 收到：\(value)")
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        .disposed(by: disposeBag)

        // 4. 发送第二个值（更新内部存储的“当前值”为“发送值2”）
        behaviorSubject.onNext("发送值2")

        // 5. 第二次订阅：订阅时立即收到“最新值（发送值2）”
        behaviorSubject.subscribe(onNext: { value in
            print("订阅者2 收到：\(value)")
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        .disposed(by: disposeBag)

        // 6. 直接获取当前值（存值的额外体现：可主动读取内部存储的值）
        if let currentValue = try? behaviorSubject.value() {
            print("直接读取 BehaviorSubject 当前值：\(currentValue)")
        }
    }
    
    func rxswfitPublishSubject() {
        print("\n===== PublishSubject（不存值）=====")
        // 1. 创建：无初始值（不存值的第一个体现）
        let publishSubject = PublishSubject<String>()

        // 2. 发送第一个值（无存储，仅转发，此时无订阅者，事件丢失）
        publishSubject.onNext("发送值1")

        // 3. 第一次订阅：订阅前的“发送值1”已丢失，只能等后续事件
        publishSubject.subscribe(onNext: { value in
            print("订阅者1 收到：\(value)")
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        .disposed(by: disposeBag)

        // 4. 发送第二个值（实时转发给订阅者1）
        publishSubject.onNext("发送值2")

        // 5. 第二次订阅：订阅前的“发送值2”已丢失，只能等后续事件
        publishSubject.subscribe(onNext: { value in
            print("订阅者2 收到：\(value)")
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        .disposed(by: disposeBag)

        // 6. 发送第三个值（同时转发给订阅者1和订阅者2）
        publishSubject.onNext("发送值3")

        // 7. 无“直接获取当前值”的方法（不存值的额外体现）
        // publishSubject.value() // 编译报错：PublishSubject 无此方法
    }
    
    
    
    func combinecurrentValueSubject() {
        print("===== CurrentValueSubject（存值）=====")
        // 1. 创建：必须指定初始值（存值的第一个体现）
        let currentValueSubject = CurrentValueSubject<String, Never>("初始值")

        // 2. 发送第一个值（更新内部存储的“当前值”）
        currentValueSubject.send("发送值1")

        // 3. 第一次订阅：订阅时立即收到“最新值（发送值1）”
        currentValueSubject.sink { value in
            print("订阅者1 收到：\(value)")
        }
        .store(in: &cancellables)

        // 4. 发送第二个值（更新内部存储的“当前值”为“发送值2”）
        currentValueSubject.send("发送值2")

        // 5. 第二次订阅：订阅时立即收到“最新值（发送值2）”
        currentValueSubject.sink { value in
            print("订阅者2 收到：\(value)")
        }
        .store(in: &cancellables)

        // 6. 直接获取当前值（存值的额外体现：通过value属性读取）
        print("直接读取 CurrentValueSubject 当前值：\(currentValueSubject.value)")
    }
    
    func passthroughSubject() {
        print("\n===== PassthroughSubject（不存值）=====")
        // 1. 创建：无初始值（不存值的第一个体现）
        let passthroughSubject = PassthroughSubject<String, Never>()

        // 2. 发送第一个值（无存储，仅转发，此时无订阅者，事件丢失）
        passthroughSubject.send("发送值1")

        // 3. 第一次订阅：订阅前的“发送值1”已丢失，只能等后续事件
        passthroughSubject.sink { value in
            print("订阅者1 收到：\(value)")
        }
        .store(in: &cancellables)

        // 4. 发送第二个值（实时转发给订阅者1）
        passthroughSubject.send("发送值2")

        // 5. 第二次订阅：订阅前的“发送值2”已丢失，只能等后续事件
        passthroughSubject.sink { value in
            print("订阅者2 收到：\(value)")
        }
        .store(in: &cancellables)

        // 6. 发送第三个值（同时转发给订阅者1和订阅者2）
        passthroughSubject.send("发送值3")

        // 7. 无“直接获取当前值”的属性（不存值的额外体现）
        // passthroughSubject.value // 编译报错：PassthroughSubject 无此属性
    }
    
    
    
    init(authService: RxAuthServicing = RxMockAuthService()) {
        self.authService = authService

        let credentials = Observable.combineLatest(username.asObservable(), password.asObservable())

        isLoginEnabled = credentials
            .map { username, password in
                username.count >= 3 && password.count >= 6
            }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)

        errorMessage = loginResult
            .map { result -> String? in
                if case .failure(let error) = result {
                    return error.localizedDescription
                }
                return nil
            }
            .asDriver(onErrorJustReturn: "未知错误")

        loginSuccess = loginResult
            .compactMap { result in
                if case .success(let user) = result { return user }
                return nil
            }
            .asSignal(onErrorSignalWith: .empty())

        routeToRegister = registerTapped
            .withLatestFrom(username.asObservable())
            .asSignal(onErrorSignalWith: .empty())

        loginTapped
            .withLatestFrom(credentials)
            .do(onNext: { [weak self] _ in self?.isLoading.accept(true) })
            .flatMapLatest { [weak self] username, password -> Observable<Result<RxMVVMLoginUser, RxLoginError>> in
                guard let self else { return .empty() }
                return self.performLogin(username: username, password: password)
                    .map { .success($0) }
                    .catch { error in
                        let mapped = (error as? RxLoginError) ?? .serverError
                        return .just(.failure(mapped))
                    }
            }
            .do(onNext: { [weak self] _ in self?.isLoading.accept(false) })
            .bind(to: loginResult)
            .disposed(by: disposeBag)
    }

    func applyRegisteredUsername(_ username: String) {
        self.username.accept(username)
    }

    private func performLogin(username: String, password: String) -> Observable<RxMVVMLoginUser> {
        Observable<RxMVVMLoginUser>.create { [authService] observer in
            let task = Task {
                do {
                    let user = try await authService.login(.init(username: username, password: password))
                    observer.onNext(user)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }

            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    // MARK: - RxSwift 核心概念演示方法
    func runComprehensiveRxDemo() {
        print("\n🚀 --- 开始 RxSwift 全面演示 ---")
        
        demoSubjects()
        demoTransformingOperators()
        demoFilteringOperators()
        demoCombiningOperators()
        demoTraits()
        demoErrorHandling()
        
        print("🚀 --- RxSwift 演示结束 --- \n")
    }
    
    // 1. Subjects 演示: 它是既是 Observer 又是 Observable 的桥梁
    private func demoSubjects() {
        print("\n--- 1. Subjects 演示 ---")
        
        // PublishSubject: 订阅后只能收到订阅后的事件
        let publishSubject = PublishSubject<String>()
        publishSubject.onNext("❌ 订阅前的数据 (看不到)")
        publishSubject.subscribe(onNext: { print("PublishSubject 收到: \($0)") }).disposed(by: disposeBag)
        publishSubject.onNext("✅ 订阅后的第一条数据")
        
        // BehaviorSubject: 订阅后会立即收到最近的一条数据（或初始值）
        let behaviorSubject = BehaviorSubject<String>(value: "🍎 初始值")
        behaviorSubject.subscribe(onNext: { print("BehaviorSubject 收到: \($0)") }).disposed(by: disposeBag)
        behaviorSubject.onNext("🍌 更新值")
        
        // ReplaySubject: 订阅后会回放 bufferSize 数量的历史数据
        let replaySubject = ReplaySubject<String>.create(bufferSize: 2)
        replaySubject.onNext("1")
        replaySubject.onNext("2")
        replaySubject.onNext("3")
        replaySubject.subscribe(onNext: { print("ReplaySubject 收到: \($0)") }).disposed(by: disposeBag)
    }
    
    // 2. 转换操作符 (Transforming)
    private func demoTransformingOperators() {
        print("\n--- 2. 转换操作符演示 ---")
        
        // map: 数据转换
        Observable.of(1, 2, 3)
            .map { "数字: \($0 * 10)" }
            .subscribe(onNext: { print("map: \($0)") })
            .disposed(by: disposeBag)
            
        // scan: 类似 reduce，但会发射中间结果 (常用于累加计算)
        Observable.of(1, 2, 3, 4, 5)
            .scan(0) { aggregate, value in aggregate + value }
            .subscribe(onNext: { print("scan (累加): \($0)") })
            .disposed(by: disposeBag)
            
        // flatMap: 将元素转换为 Observable，并拍平到一个流中
        // flatMapLatest: 只接收最新的内部 Observable 的事件
    }
    
    // 3. 过滤操作符 (Filtering)
    private func demoFilteringOperators() {
        print("\n--- 3. 过滤操作符演示 ---")
        
        // distinctUntilChanged: 过滤连续重复的数据
        Observable.of(1, 1, 2, 2, 3, 1)
            .distinctUntilChanged()
            .subscribe(onNext: { print("distinctUntilChanged: \($0)") })
            .disposed(by: disposeBag)
            
        // skip: 跳过前 N 个
        Observable.of("A", "B", "C", "D")
            .skip(2)
            .subscribe(onNext: { print("skip(2): \($0)") })
            .disposed(by: disposeBag)
    }
    
    // 4. 结合操作符 (Combining)
    private func demoCombiningOperators() {
        print("\n--- 4. 结合操作符演示 ---")
        
        let left = PublishSubject<String>()
        let right = PublishSubject<String>()
        
        // combineLatest: 任何一个流发数据，都取所有流最新的值组合
        Observable.combineLatest(left, right) { "\($0)-\($1)" }
            .subscribe(onNext: { print("combineLatest: \($0)") })
            .disposed(by: disposeBag)
            
        left.onNext("L1")
        right.onNext("R1")
        left.onNext("L2")
        
        // merge: 多个流合并成一个流，类型必须相同
        Observable.merge(Observable.just("A"), Observable.just("B"))
            .subscribe(onNext: { print("merge: \($0)") })
            .disposed(by: disposeBag)
    }
    
    // 5. 特征序列 (Traits): 针对特定场景的 Observable 包装
    private func demoTraits() {
        print("\n--- 5. Traits 演示 ---")
        
        // Single: 只发一个值或一个错误 (常用于网络请求)
        Single<String>.create { single in
            single(.success("✅ Single 成功结果"))
            return Disposables.create()
        }
        .subscribe(onSuccess: { print("Single: \($0)") })
        .disposed(by: disposeBag)
        
        // Completable: 只发完成或错误，不发数据 (常用于存盘等)
        Completable.empty()
            .subscribe(onCompleted: { print("Completable: 已完成") })
            .disposed(by: disposeBag)
    }
    
    // 6. 错误处理 (Error Handling)
    private func demoErrorHandling() {
        print("\n--- 6. 错误处理演示 ---")
        
        let subject = PublishSubject<String>()
        
        subject
            .catch { error in
                return Observable.just("🛠 发生错误，这是降级后的默认值")
            }
            .subscribe(onNext: { print("Error Handling: \($0)") })
            .disposed(by: disposeBag)
            
        subject.onError(RxLoginError.networkError)
    }
}
