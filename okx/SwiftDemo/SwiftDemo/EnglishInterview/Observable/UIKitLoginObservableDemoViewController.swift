import UIKit
import Observation

// MARK: - LoginViewModel (MVVM)
@Observable
class UIKitLoginViewModel {
    // Input
    var username = ""
    var password = ""
    
    // Output
    var isLoading = false
    var errorMessage: String?
    var isLoggedIn = false
    
    // Derived
    var isLoginButtonEnabled: Bool {
        !username.isEmpty && password.count >= 6 && !isLoading
    }
    
    // Actions
    func login() {
        guard isLoginButtonEnabled else { return }
        
        isLoading = true
        errorMessage = nil
        
        // Simulate network login
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isLoading = false
            if self.username == "admin" && self.password == "123456" {
                self.isLoggedIn = true
                self.errorMessage = nil
            } else {
                self.isLoggedIn = false
                self.errorMessage = "Invalid username or password (use admin/123456)"
            }
        }
    }
    
    func logout() {
        isLoggedIn = false
        username = ""
        password = ""
        errorMessage = nil
    }
}

// MARK: - LoginViewController
class UIKitLoginObservableDemoViewController: UIViewController {
    
    private let viewModel = UIKitLoginViewModel()
    
    // UI Elements
    private let usernameField = UITextField()
    private let passwordField = UITextField()
    private let loginButton = UIButton(type: .system)
    private let errorLabel = UILabel()
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private let welcomeLabel = UILabel()
    private let logoutButton = UIButton(type: .system)
    private let containerStack = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
        
        // Initial observation
        observeViewModel()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Login with @Observable (UIKit)"
        
        usernameField.placeholder = "Username (admin)"
        usernameField.borderStyle = .roundedRect
        usernameField.autocapitalizationType = .none
        
        passwordField.placeholder = "Password (123456)"
        passwordField.borderStyle = .roundedRect
        passwordField.isSecureTextEntry = true
        
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 8
        
        errorLabel.textColor = .systemRed
        errorLabel.font = .systemFont(ofSize: 14)
        errorLabel.numberOfLines = 0
        errorLabel.textAlignment = .center
        
        welcomeLabel.font = .systemFont(ofSize: 20, weight: .bold)
        welcomeLabel.textAlignment = .center
        welcomeLabel.isHidden = true
        
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.setTitleColor(.systemRed, for: .normal)
        logoutButton.isHidden = true
        
        containerStack.axis = .vertical
        containerStack.spacing = 20
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        
        [usernameField, passwordField, loginButton, errorLabel, welcomeLabel, logoutButton].forEach {
            containerStack.addArrangedSubview($0)
        }
        
        view.addSubview(containerStack)
        view.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            containerStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            loginButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupActions() {
        usernameField.addTarget(self, action: #selector(usernameChanged), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)
    }
    
    // MARK: - Observation Logic
    private func observeViewModel() {
        withObservationTracking {
            // Track dependencies
            let loggedIn = viewModel.isLoggedIn
            let loading = viewModel.isLoading
            let error = viewModel.errorMessage
            let buttonEnabled = viewModel.isLoginButtonEnabled
            
            // Update UI
            self.updateUI(loggedIn: loggedIn, loading: loading, error: error, buttonEnabled: buttonEnabled)
            
        } onChange: { [weak self] in
            DispatchQueue.main.async {
                self?.observeViewModel()
            }
        }
    }
    
    private func updateUI(loggedIn: Bool, loading: Bool, error: String?, buttonEnabled: Bool) {
        // Handle Visibility
        usernameField.isHidden = loggedIn
        passwordField.isHidden = loggedIn
        loginButton.isHidden = loggedIn
        welcomeLabel.isHidden = !loggedIn
        logoutButton.isHidden = !loggedIn
        
        welcomeLabel.text = "Welcome, \(viewModel.username)!"
        errorLabel.text = error
        
        loginButton.isEnabled = buttonEnabled
        loginButton.alpha = buttonEnabled ? 1.0 : 0.5
        
        if loading {
            loadingIndicator.startAnimating()
            loginButton.setTitle("", for: .normal)
        } else {
            loadingIndicator.stopAnimating()
            loginButton.setTitle("Login", for: .normal)
        }
    }
    
    // MARK: - Handlers
    @objc private func usernameChanged() {
        viewModel.username = usernameField.text ?? ""
    }
    
    @objc private func passwordChanged() {
        viewModel.password = passwordField.text ?? ""
    }
    
    @objc private func didTapLogin() {
        view.endEditing(true)
        viewModel.login()
    }
    
    @objc private func didTapLogout() {
        viewModel.logout()
        usernameField.text = ""
        passwordField.text = ""
    }
}
