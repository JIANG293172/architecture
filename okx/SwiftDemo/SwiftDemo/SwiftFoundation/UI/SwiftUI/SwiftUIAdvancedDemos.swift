import SwiftUI

// 87. How to handle user input in SwiftUI
struct UserInputDemoView: View {
    @State private var text = ""
    @State private var isToggled = false
    @State private var sliderValue = 0.5
    
    var body: some View {
        Form {
            Section(header: Text("Inputs")) {
                TextField("Enter text", text: $text)
                Toggle("Is Toggled", isOn: $isToggled)
                Slider(value: $sliderValue)
                Text("Value: \(sliderValue, specifier: "%.2f")")
            }
            
            Section(header: Text("Interview Principles")) {
                Text("Handle input using two-way binding (@Binding). Use components like TextField, Toggle, and Slider which are state-driven.")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .navigationTitle("User Input")
    }
}

// 89. How to perform animations in SwiftUI
struct AnimationDemoView: View {
    @State private var scale: CGFloat = 1.0
    @State private var angle: Double = 0.0
    
    var body: some View {
        VStack(spacing: 40) {
            SwiftUI.Circle()
                .fill(Color.blue)
                .frame(width: 100, height: 100)
                .scaleEffect(scale)
                .rotationEffect(Angle.degrees(angle))
            
            Button("Animate (implicit)") {
                scale = (scale == 1.0 ? 1.5 : 1.0)
            }
            .animation(.spring(), value: scale)
            
            Button("Animate (explicit)") {
                withAnimation(.easeInOut(duration: 1.0)) {
                    angle += 45
                }
            }
            
            Text("Interview Tip: Use implicit animation (.animation()) for individual views or explicit animation (withAnimation {}) to animate state changes globally.")
                .font(.caption)
                .foregroundColor(.gray)
                .padding()
        }
        .navigationTitle("Animations")
    }
}

// 90. What is ViewBuilder
struct ViewBuilderDemoView: View {
    var body: some View {
        VStack {
            CustomContainer {
                Text("Item 1")
                Text("Item 2")
                Image(systemName: "star.fill")
            }
            
            Text("Interview Tip: @ViewBuilder is a parameter attribute that allows creating views from closures by collecting multiple views into a single container.")
                .font(.caption)
                .foregroundColor(.gray)
                .padding()
        }
        .navigationTitle("ViewBuilder")
    }
}

struct CustomContainer<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    var body: some View {
        VStack {
            Text("Container Start")
                .font(.headline)
            content
                .padding()
                .border(Color.red)
            Text("Container End")
                .font(.headline)
        }
    }
}

// 94. @AppStorage
struct AppStorageDemoView: View {
    @AppStorage("username") var username: String = "Guest"
    
    var body: some View {
        VStack {
            Text("Stored Username: \(username)")
            TextField("Change Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Text("Interview Tip: @AppStorage is a property wrapper for reading/writing to UserDefaults. It automatically invalidates the view when the stored value changes.")
                .font(.caption)
                .foregroundColor(.gray)
                .padding()
        }
        .navigationTitle("@AppStorage")
    }
}

// 95. @SceneStorage
struct SceneStorageDemoView: View {
    @SceneStorage("selectedTab") var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Text("Tab 1 Content")
                .tabItem { Text("Tab 1") }
                .tag(0)
            
            Text("Tab 2 Content")
                .tabItem { Text("Tab 2") }
                .tag(1)
        }
        .navigationTitle("@SceneStorage")
        .overlay(
            VStack {
                Spacer()
                Text("Interview Tip: @SceneStorage is used for state restoration. It saves and restores small amounts of data for each scene (window) automatically.")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding()
                    .background(Color.white.opacity(0.8))
            }
        )
    }
}

// 96. Life-cycle (onAppear/onDisappear)
struct LifecycleDemoView: View {
    @State private var status = "Waiting..."
    
    var body: some View {
        Text("Status: \(status)")
            .onAppear {
                status = "View Appeared!"
                print("Lifecycle: onAppear")
            }
            .onDisappear {
                print("Lifecycle: onDisappear")
            }
            .navigationTitle("Life Cycle")
    }
}

// 101. Concurrency in SwiftUI
struct ConcurrencyDemoView: View {
    @State private var data = "Loading..."
    
    var body: some View {
        VStack {
            Text(data)
                .padding()
            
            Button("Fetch Data (Async/Await)") {
                Task {
                    await fetchData()
                }
            }
            
            Text("Interview Tip: Use the Task {} modifier or Task block to perform asynchronous work using Swift Concurrency (async/await).")
                .font(.caption)
                .foregroundColor(.gray)
                .padding()
        }
        .navigationTitle("Concurrency")
    }
    
    func fetchData() async {
        try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
        data = "Data fetched successfully at \(Date().formatted(date: .omitted, time: .shortened))"
    }
}

// 99. PreferenceKey
struct PreferenceDemoView: View {
    @State private var childSize: CGSize = .zero
    
    var body: some View {
        VStack {
            Text("Child size: \(Int(childSize.width))x\(Int(childSize.height))")
                .padding()
            
            ChildView()
                .onPreferenceChange(MyPreferenceKey.self) { value in
                    childSize = value
                }
            
            Text("Interview Tip: Preferences are used to pass data up the view tree (from child to parent), the opposite of Environment/State which pass data down.")
                .font(.caption)
                .foregroundColor(.gray)
                .padding()
        }
        .navigationTitle("Preferences")
    }
}

struct MyPreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct ChildView: View {
    var body: some View {
        Rectangle()
            .fill(Color.green)
            .frame(width: 100, height: 50)
            .preference(key: MyPreferenceKey.self, value: CGSize(width: 100, height: 50))
    }
}
