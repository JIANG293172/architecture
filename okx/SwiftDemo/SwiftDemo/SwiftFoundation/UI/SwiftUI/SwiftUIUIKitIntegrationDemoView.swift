import SwiftUI
import UIKit
import MapKit

// 91. How to integrate UIKit into SwiftUI (UIViewRepresentable)
struct MapViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let coordinate = CLLocationCoordinate2D(latitude: 34.011286, longitude: -116.166868)
        let span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        uiView.setRegion(region, animated: true)
    }
}

// 91. UIViewControllerRepresentable example
struct ImagePickerRepresentable: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePickerRepresentable
        init(_ parent: ImagePickerRepresentable) { self.parent = parent }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct SwiftUIUIKitIntegrationDemoView: View {
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("UIViewRepresentable (MapKit)")
                    .font(.headline)
                MapViewRepresentable()
                    .frame(height: 200)
                    .cornerRadius(12)
                    .padding(.horizontal)
                
                Divider()
                
                Text("UIViewControllerRepresentable (ImagePicker)")
                    .font(.headline)
                Button("Select Image") {
                    showingImagePicker = true
                }
                if let image = inputImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                }
                
                Divider()
                
                Text("92. SwiftUI into UIKit (UIHostingController)")
                    .font(.headline)
                Text("To use SwiftUI in UIKit, wrap your SwiftUI view in a UIHostingController:")
                    .font(.subheadline)
                Text("""
                let swiftUIView = MySwiftUIView()
                let hostingController = UIHostingController(rootView: swiftUIView)
                navigationController?.pushViewController(hostingController, animated: true)
                """)
                .font(.system(.caption, design: .monospaced))
                .padding()
                .background(Color.black.opacity(0.1))
                
                Divider()
                
                Text("Interview Tip: Use UIViewRepresentable for UIKit Views and UIViewControllerRepresentable for UIKit ViewControllers. For the reverse (SwiftUI in UIKit), use UIHostingController.")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding()
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePickerRepresentable(image: $inputImage)
        }
        .navigationTitle("UIKit Integration")
    }
}
