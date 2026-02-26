import SwiftUI
import Combine

// 2. SwiftUI + Combine Login Demo
class SwiftUILoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isValid = false
    @Published var isLoading = false
    @Published var loginMessage = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Validation logic using Combine
        Publishers.CombineLatest($email, $password)
            .map { email, password in
                email.contains("@") && password.count >= 6
            }
            .assign(to: &$isValid)
    }
    
    func login() {
        isLoading = true
        loginMessage = "Logging in..."
        
        // Simulate network request
        Just(true)
            .delay(for: .seconds(2), scheduler: RunLoop.main)
            .sink { [weak self] success in
                self?.isLoading = false
                self?.loginMessage = success ? "Login Successful!" : "Login Failed"
            }
            .store(in: &cancellables)
    }
}

struct SwiftUILoginDemoView: View {
    @StateObject private var viewModel = SwiftUILoginViewModel()
    
    var body: some View {
        Form {
            Section(header: Text("Credentials")) {
                TextField("Email", text: $viewModel.email)
                
                SecureField("Password", text: $viewModel.password)
            }
            
            Section {
                Button(action: viewModel.login) {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Text("Login")
                    }
                }
                .disabled(!viewModel.isValid || viewModel.isLoading)
            }
            
            Section {
                Text(viewModel.loginMessage)
                    .foregroundColor(viewModel.loginMessage.contains("Successful") ? .green : .red)
            }
            
            Section(header: Text("Interview Principles")) {
                Text("• Combine integration: Uses Publishers.CombineLatest to validate inputs reactively.\n• @Published & @StateObject: Drives UI updates when data changes.\n• Network Simulation: Uses Just and delay to mimic asynchronous API calls.")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .navigationTitle("Combine Login")
    }
}
