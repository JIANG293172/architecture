import SwiftUI
import Combine

// MARK: - SwiftUI Demo Models & ViewModels

struct DemoItem: Identifiable {
    let id: Int
    let title: String
    let description: String
    let view: AnyView
}

class SwiftUIProtocolViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var isEnabled: Bool = false
    @Published var items: [String] = ["SwiftUI", "Combine", "Concurrency"]
    
    func addItem() {
        items.append("New Item \(items.count + 1)")
    }
}

// MARK: - Core SwiftUI Demos (76-100)

// 78. @State Demo
struct StateDemoView: View {
    @State private var count = 0
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Count: \(count)")
                .font(.largeTitle)
            Button("Increment") {
                count += 1
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            Text("Interview Tip: @State is a property wrapper for simple, local state within a view. When the state changes, SwiftUI automatically invalidates the view and re-renders the body.")
                .font(.caption)
                .foregroundColor(.gray)
                .padding()
        }
    }
}

// 79. @Binding Demo
struct BindingDemoView: View {
    @State private var isOn = false
    
    var body: some View {
        VStack {
            Text("Parent State: \(isOn ? "ON" : "OFF")")
            ToggleChildView(isOn: $isOn)
            
            Text("Interview Tip: @Binding creates a two-way connection between a property that stores data (@State in parent) and a view that displays and changes that data (child view).")
                .font(.caption)
                .foregroundColor(.gray)
                .padding()
        }
    }
}

struct ToggleChildView: View {
    @Binding var isOn: Bool
    var body: some View {
        Toggle("Child Toggle", isOn: $isOn)
            .padding()
    }
}

// 80/81. @StateObject vs @ObservedObject
class TimerManager: ObservableObject {
    @Published var seconds = 0
    private var timer: AnyCancellable?
    
    init() {
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in self.seconds += 1 }
    }
}

struct ObjectDemoView: View {
    @StateObject private var stateObj = TimerManager()
    
    var body: some View {
        VStack {
            Text("Seconds: \(stateObj.seconds)")
            
            Text("Interview Tip: @StateObject ensures the object is created only once and persists across view updates. @ObservedObject should be used for objects passed from outside where the view doesn't own the lifecycle.")
                .font(.caption)
                .foregroundColor(.gray)
                .padding()
        }
    }
}

// 84. Stacks (VStack, HStack, ZStack)
struct StacksDemoView: View {
    var body: some View {
        VStack {
            HStack {
                Rectangle().fill(Color.red).frame(width: 50, height: 50)
                Rectangle().fill(Color.green).frame(width: 50, height: 50)
                Rectangle().fill(Color.blue).frame(width: 50, height: 50)
            }
            ZStack {
                SwiftUI.Circle().fill(Color.yellow).frame(width: 100, height: 100)
                Text("Z").font(.largeTitle)
            }
            
            Text("Interview Tip: Stacks are the primary layout containers. VStack (Vertical), HStack (Horizontal), and ZStack (Depth-based).")
                .font(.caption)
                .foregroundColor(.gray)
                .padding()
        }
    }
}

// 97. GeometryReader
struct GeometryDemoView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Width: \(geometry.size.width)")
                Text("Height: \(geometry.size.height)")
                Rectangle()
                    .fill(Color.orange)
                    .frame(width: geometry.size.width * 0.5, height: 50)
            }
        }
        .frame(height: 150)
        .border(Color.black)
        .padding()
    }
}

// 98. Custom Modifier
struct CustomModifierDemoView: View {
    var body: some View {
        Text("Styled with Modifier")
            .modifier(PrimaryButtonModifier())
    }
}

struct PrimaryButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.purple)
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
}

// 100. AsyncImage
struct AsyncImageDemoView: View {
    let url = URL(string: "https://developer.apple.com/assets/elements/icons/swiftui/swiftui-96x96_2x.png")
    
    var body: some View {
        VStack {
            AsyncImage(url: url) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 100, height: 100)
            
            Text("Interview Tip: AsyncImage loads images from a URL asynchronously, handling states like loading, success, and failure automatically.")
                .font(.caption)
                .foregroundColor(.gray)
                .padding()
        }
    }
}

// MARK: - Main SwiftUI Demo List View

struct SwiftUIDemoListView: View {
    let demos: [DemoItem] = [
        DemoItem(id: 76, title: "76. What is SwiftUI?", description: "Declarative UI Framework", view: AnyView(Text("SwiftUI is a declarative framework for building UIs across Apple platforms. It uses a state-driven approach where the UI is a function of its state."))),
        DemoItem(id: 78, title: "78. @State", description: "Local State Management", view: AnyView(StateDemoView())),
        DemoItem(id: 79, title: "79. @Binding", description: "Two-way Data Binding", view: AnyView(BindingDemoView())),
        DemoItem(id: 81, title: "81. @StateObject", description: "Owned Observable Objects", view: AnyView(ObjectDemoView())),
        DemoItem(id: 84, title: "84. Stacks (V/H/Z)", description: "Layout Containers", view: AnyView(StacksDemoView())),
        DemoItem(id: 88, title: "88. View Modifiers", description: "Transforming Views", view: AnyView(Text("Modifiers are methods that create a new view by transforming an existing one (e.g., .padding(), .font()).").padding())),
        DemoItem(id: 91, title: "91. UIKit Integration", description: "UIViewRepresentable", view: AnyView(Text("Use UIViewRepresentable to wrap UIKit views (like MKMapView) into SwiftUI views."))),
        DemoItem(id: 93, title: "93. AnyView", description: "Type Erasure for Views", view: AnyView(Text("AnyView is a type-erased view. Use it when you need to return different view types from a single property or function."))),
        DemoItem(id: 97, title: "97. GeometryReader", description: "Parent Size Awareness", view: AnyView(GeometryDemoView())),
        DemoItem(id: 98, title: "98. Custom Modifiers", description: "Reusable View Styles", view: AnyView(CustomModifierDemoView())),
        DemoItem(id: 100, title: "100. AsyncImage", description: "Remote Image Loading", view: AnyView(AsyncImageDemoView()))
    ]
    
    var body: some View {
        List(demos) { demo in
            NavigationLink(destination: demo.view.navigationTitle(demo.title)) {
                VStack(alignment: .leading) {
                    Text(demo.title).font(.headline)
                    Text(demo.description).font(.subheadline).foregroundColor(.gray)
                }
            }
        }
        .navigationTitle("SwiftUI Interview Demos")
    }
}
