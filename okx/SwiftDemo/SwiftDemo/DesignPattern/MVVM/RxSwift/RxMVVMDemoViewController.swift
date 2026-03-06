import UIKit
import RxSwift
import RxCocoa

final class RxMVVMDemoViewController: UIViewController {
    private var coordinator: RxAuthCoordinator?
    private let startButton = UIButton(type: .system)
    private let descriptionLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MVVM + RxSwift 登录 Demo"
        view.backgroundColor = .white
        setupUI()
    }

    private func setupUI() {
        descriptionLabel.frame = CGRect(x: 20, y: 120, width: view.frame.width - 40, height: 120)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = .black
        descriptionLabel.text = "完整登录 Demo\n- MVVM + RxSwift\n- Coordinator 跳转注册页面"
        view.addSubview(descriptionLabel)

        startButton.frame = CGRect(x: 80, y: 280, width: view.frame.width - 160, height: 50)
        startButton.setTitle("Start", for: .normal)
        startButton.setTitleColor(.white, for: .normal)
        startButton.backgroundColor = .systemBlue
        startButton.layer.cornerRadius = 25
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        startButton.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
        view.addSubview(startButton)
    }

    @objc private func startTapped() {
        let navigationController = UINavigationController()
        coordinator = RxAuthCoordinator(navigationController: navigationController)
        coordinator?.start()
        present(navigationController, animated: true)
    }
}

private protocol RxAuthFlowCoordinating: AnyObject {
    func showRegister(prefilledUsername: String)
    func didRegister(username: String)
    func didLogin(user: RxMVVMLoginUser)
    func dismissFlow()
}

private final class RxAuthCoordinator: Coordinator, RxAuthFlowCoordinating {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    private let authService: RxAuthServicing
    private let loginViewModel: RxMVVMLoginViewModel

    init(navigationController: UINavigationController, authService: RxAuthServicing = RxMockAuthService()) {
        self.navigationController = navigationController
        self.authService = authService
        self.loginViewModel = RxMVVMLoginViewModel(authService: authService)
    }

    func start() {
        let loginVC = RxMVVMLoginViewController(viewModel: loginViewModel)
        loginVC.coordinator = self
        navigationController.setViewControllers([loginVC], animated: false)
        navigationController.navigationBar.prefersLargeTitles = false
    }

    func showRegister(prefilledUsername: String) {
        let registerVM = RxMVVMRegisterViewModel(authService: authService, prefilledUsername: prefilledUsername)
        let registerVC = RxMVVMRegisterViewController(viewModel: registerVM)
        registerVC.coordinator = self
        navigationController.pushViewController(registerVC, animated: true)
    }

    func didRegister(username: String) {
        loginViewModel.applyRegisteredUsername(username)
        navigationController.popViewController(animated: true)
    }

    func didLogin(user: RxMVVMLoginUser) {
        let alert = UIAlertController(title: "登录成功", message: "欢迎，\(user.username)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default) { [weak self] _ in
            self?.dismissFlow()
        })
        navigationController.present(alert, animated: true)
    }

    func dismissFlow() {
        navigationController.dismiss(animated: true)
    }
}

private final class RxMVVMLoginViewController: UIViewController {
    weak var coordinator: RxAuthFlowCoordinating?

    private let viewModel: RxMVVMLoginViewModel
    private let disposeBag = DisposeBag()

    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let usernameTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton(type: .system)
    private let registerButton = UIButton(type: .system)
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    private let statusLabel = UILabel()

    init(viewModel: RxMVVMLoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "登录"
        view.backgroundColor = .systemGroupedBackground
        setupUI()
        setupBindings()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(closeTapped))
    }

    @objc private func closeTapped() {
        coordinator?.dismissFlow()
    }

    private func setupUI() {
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 12
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)

        titleLabel.text = "用户登录"
        titleLabel.font = .boldSystemFont(ofSize: 22)
        titleLabel.textAlignment = .center

        usernameTextField.placeholder = "用户名 (至少3位)"
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.autocapitalizationType = .none

        passwordTextField.placeholder = "密码 (至少6位)"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true

        loginButton.setTitle("登录", for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.setTitleColor(.lightGray, for: .disabled)
        loginButton.layer.cornerRadius = 8
        loginButton.heightAnchor.constraint(equalToConstant: 44).isActive = true

        registerButton.setTitle("去注册", for: .normal)
        registerButton.backgroundColor = .systemGray
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.layer.cornerRadius = 8
        registerButton.heightAnchor.constraint(equalToConstant: 44).isActive = true

        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 0
        statusLabel.font = .systemFont(ofSize: 14)
        statusLabel.textColor = .secondaryLabel

        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            usernameTextField,
            passwordTextField,
            loginButton,
            registerButton,
            statusLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackView)

        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingIndicator)

        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24),

            loadingIndicator.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor)
        ])
    }

    private func setupBindings() {
        usernameTextField.rx.text.orEmpty
            .bind(to: viewModel.username)
            .disposed(by: disposeBag)

        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)

        loginButton.rx.tap
            .bind(to: viewModel.loginTapped)
            .disposed(by: disposeBag)

        registerButton.rx.tap
            .bind(to: viewModel.registerTapped)
            .disposed(by: disposeBag)

        viewModel.isLoginEnabled
            .drive(loginButton.rx.isEnabled)
            .disposed(by: disposeBag)

        viewModel.isLoginEnabled
            .map { $0 ? 1.0 : 0.5 }
            .drive(loginButton.rx.alpha)
            .disposed(by: disposeBag)

        viewModel.isLoading
            .asDriver(onErrorJustReturn: false)
            .drive(loadingIndicator.rx.isAnimating)
            .disposed(by: disposeBag)

        viewModel.isLoading
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] loading in
                self?.loginButton.setTitle(loading ? "" : "登录", for: .normal)
                self?.usernameTextField.isEnabled = !loading
                self?.passwordTextField.isEnabled = !loading
            })
            .disposed(by: disposeBag)

        viewModel.errorMessage
            .drive(onNext: { [weak self] message in
                guard let self else { return }
                if let message, !message.isEmpty {
                    self.statusLabel.textColor = .systemRed
                    self.statusLabel.text = message
                } else {
                    self.statusLabel.textColor = .secondaryLabel
                    self.statusLabel.text = ""
                }
            })
            .disposed(by: disposeBag)

        viewModel.routeToRegister
            .emit(onNext: { [weak self] username in
                self?.coordinator?.showRegister(prefilledUsername: username)
            })
            .disposed(by: disposeBag)

        viewModel.loginSuccess
            .emit(onNext: { [weak self] user in
                self?.coordinator?.didLogin(user: user)
            })
            .disposed(by: disposeBag)
    }
}

private final class RxMVVMRegisterViewModel {
    let username = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")
    let confirmPassword = BehaviorRelay<String>(value: "")
    let registerTapped = PublishRelay<Void>()

    let isRegisterEnabled: Driver<Bool>
    let isLoading = BehaviorRelay<Bool>(value: false)
    let errorMessage: Driver<String?>
    let registered: Signal<String>

    private let authService: RxAuthServicing
    private let disposeBag = DisposeBag()
    private let registerResult = PublishRelay<Result<String, Error>>()

    init(authService: RxAuthServicing, prefilledUsername: String) {
        self.authService = authService
        username.accept(prefilledUsername)

        let form = Observable.combineLatest(username.asObservable(), password.asObservable(), confirmPassword.asObservable())

        isRegisterEnabled = form
            .map { username, password, confirm in
                username.count >= 3 && password.count >= 6 && password == confirm
            }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)

        errorMessage = registerResult
            .map { result -> String? in
                if case .failure(let error) = result {
                    return (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
                }
                return nil
            }
            .asDriver(onErrorJustReturn: "未知错误")

        registered = registerResult
            .compactMap { result -> String? in
                if case .success(let username) = result { return username }
                return nil
            }
            .asSignal(onErrorSignalWith: .empty())

        registerTapped
            .withLatestFrom(form)
            .do(onNext: { [weak self] _ in self?.isLoading.accept(true) })
            .flatMapLatest { [weak self] username, password, confirm -> Observable<Result<String, Error>> in
                guard let self else { return .empty() }
                guard password == confirm else {
                    return .just(.failure(RxRegisterError.passwordMismatch))
                }

                return self.performRegister(username: username, password: password)
                    .map { .success(username) }
                    .catch { error in .just(.failure(error)) }
            }
            .do(onNext: { [weak self] _ in self?.isLoading.accept(false) })
            .bind(to: registerResult)
            .disposed(by: disposeBag)
    }

    private func performRegister(username: String, password: String) -> Observable<Void> {
        Observable<Void>.create { [authService] observer in
            let task = Task {
                do {
                    try await authService.register(.init(username: username, password: password))
                    observer.onNext(())
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
}

private final class RxMVVMRegisterViewController: UIViewController {
    weak var coordinator: RxAuthFlowCoordinating?

    private let viewModel: RxMVVMRegisterViewModel
    private let disposeBag = DisposeBag()

    private let usernameTextField = UITextField()
    private let passwordTextField = UITextField()
    private let confirmPasswordTextField = UITextField()
    private let registerButton = UIButton(type: .system)
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    private let statusLabel = UILabel()

    init(viewModel: RxMVVMRegisterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "注册"
        view.backgroundColor = .systemGroupedBackground
        setupUI()
        setupBindings()
    }

    private func setupUI() {
        let containerView = UIView()
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 12
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)

        usernameTextField.placeholder = "用户名 (至少3位)"
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.autocapitalizationType = .none

        passwordTextField.placeholder = "密码 (至少6位)"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true

        confirmPasswordTextField.placeholder = "确认密码"
        confirmPasswordTextField.borderStyle = .roundedRect
        confirmPasswordTextField.isSecureTextEntry = true

        registerButton.setTitle("注册", for: .normal)
        registerButton.backgroundColor = .systemGreen
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.setTitleColor(.lightGray, for: .disabled)
        registerButton.layer.cornerRadius = 8
        registerButton.heightAnchor.constraint(equalToConstant: 44).isActive = true

        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 0
        statusLabel.font = .systemFont(ofSize: 14)
        statusLabel.textColor = .secondaryLabel

        let stackView = UIStackView(arrangedSubviews: [
            usernameTextField,
            passwordTextField,
            confirmPasswordTextField,
            registerButton,
            statusLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackView)

        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingIndicator)

        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24),

            loadingIndicator.centerXAnchor.constraint(equalTo: registerButton.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: registerButton.centerYAnchor)
        ])
    }

    private func setupBindings() {
        usernameTextField.rx.text.orEmpty
            .bind(to: viewModel.username)
            .disposed(by: disposeBag)

        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)

        confirmPasswordTextField.rx.text.orEmpty
            .bind(to: viewModel.confirmPassword)
            .disposed(by: disposeBag)

        registerButton.rx.tap
            .bind(to: viewModel.registerTapped)
            .disposed(by: disposeBag)

        viewModel.isRegisterEnabled
            .drive(registerButton.rx.isEnabled)
            .disposed(by: disposeBag)

        viewModel.isRegisterEnabled
            .map { $0 ? 1.0 : 0.5 }
            .drive(registerButton.rx.alpha)
            .disposed(by: disposeBag)

        viewModel.isLoading
            .asDriver(onErrorJustReturn: false)
            .drive(loadingIndicator.rx.isAnimating)
            .disposed(by: disposeBag)

        viewModel.isLoading
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] loading in
                self?.registerButton.setTitle(loading ? "" : "注册", for: .normal)
                self?.usernameTextField.isEnabled = !loading
                self?.passwordTextField.isEnabled = !loading
                self?.confirmPasswordTextField.isEnabled = !loading
            })
            .disposed(by: disposeBag)

        viewModel.errorMessage
            .drive(onNext: { [weak self] message in
                guard let self else { return }
                if let message, !message.isEmpty {
                    self.statusLabel.textColor = .systemRed
                    self.statusLabel.text = message
                } else {
                    self.statusLabel.textColor = .secondaryLabel
                    self.statusLabel.text = ""
                }
            })
            .disposed(by: disposeBag)

        viewModel.registered
            .emit(onNext: { [weak self] username in
                self?.coordinator?.didRegister(username: username)
            })
            .disposed(by: disposeBag)
    }
}
