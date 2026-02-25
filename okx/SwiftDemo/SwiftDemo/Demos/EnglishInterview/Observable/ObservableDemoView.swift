import SwiftUI
import Observation

// MARK: - View Model (iOS 17+)
/// Use the @Observable macro instead of ObservableObject.
/// No more @Published required! Properties are automatically observed.
@Observable
class UserProfileViewModel {
    var name: String = "John Doe"
    var age: Int = 25
    var isSubscribed: Bool = false
    
    // Derived property - Observation handles this automatically!
    var description: String {
        "\(name) is \(age) years old."
    }
    
    func incrementAge() {
        age += 1
    }
}

// MARK: - Main View
struct ObservableDemoView: View {
    // With @Observable, we use @State for objects owned by the view.
    @State private var viewModel = UserProfileViewModel()
    
    var body: some View {
        List {
            Section("Current Data") {
                LabeledContent("Name", value: viewModel.name)
                LabeledContent("Age", value: "\(viewModel.age)")
                LabeledContent("Subscribed", value: viewModel.isSubscribed ? "Yes" : "No")
                Text(viewModel.description)
                    .italic()
                    .foregroundStyle(.secondary)
            }
            
            Section("Actions") {
                Button("Increment Age") {
                    viewModel.incrementAge()
                }
                
                Toggle("Toggle Subscription", isOn: $viewModel.isSubscribed)
            }
            
            Section("Editing (Using @Bindable)") {
                // @Bindable allows creating bindings from an @Observable object
                EditProfileView(viewModel: viewModel)
            }
            
            Section("Educational Note") {
                Text("Why @Observable?")
                    .font(.headline)
                VStack(alignment: .leading, spacing: 8) {
                    bulletPoint("No more @Published required on every property.")
                    bulletPoint("Better performance: Views only update when properties they *actually read* change.")
                    bulletPoint("Simplified syntax: Use @State instead of @StateObject.")
                    bulletPoint("No need for @ObservedObject; just pass the object.")
                }
                .font(.footnote)
            }
        }
        .navigationTitle("Observation Demo")
    }
    
    private func bulletPoint(_ text: String) -> some View {
        HStack(alignment: .top) {
            Text("•")
            Text(text)
        }
    }
}

// MARK: - Subview with @Bindable
struct EditProfileView: View {
    // @Bindable creates bindings to properties of an @Observable object
    @Bindable var viewModel: UserProfileViewModel
    
    var body: some View {
        VStack {
            TextField("Edit Name", text: $viewModel.name)
                .textFieldStyle(.roundedBorder)
            
            Stepper("Age: \(viewModel.age)", value: $viewModel.age)
        }
    }
}

#Preview {
    NavigationStack {
        ObservableDemoView()
    }
}
