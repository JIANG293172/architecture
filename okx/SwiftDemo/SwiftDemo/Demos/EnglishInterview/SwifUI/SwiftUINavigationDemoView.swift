import SwiftUI

// 85. How to perform navigation in SwiftUI
struct SwiftUINavigationDemoView: View {
    @State private var showDetail = false
    
    var body: some View {
        VStack(spacing: 20) {
            // 1. NavigationLink (Standard)
            NavigationLink(destination: DetailView(message: "From NavigationLink")) {
                Text("Go to Detail (Link)")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            // 2. Programmatic Navigation
            Button("Go to Detail (Programmatic)") {
                showDetail = true
            }
            .padding()
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(8)
            .background(
                NavigationLink(destination: DetailView(message: "From Programmatic"), isActive: $showDetail) {
                    EmptyView()
                }
            )
            
            Divider()
            
            Text("Interview Tip: Navigation in SwiftUI is primarily handled by NavigationView (or NavigationStack in iOS 16+) and NavigationLink. You can also use state variables to trigger navigation programmatically.")
                .font(.caption)
                .foregroundColor(.gray)
                .padding()
        }
        .navigationTitle("Navigation Demo")
    }
}

struct DetailView: View {
    let message: String
    var body: some View {
        VStack {
            Text("Detail View")
                .font(.title)
            Text(message)
                .padding()
        }
    }
}
