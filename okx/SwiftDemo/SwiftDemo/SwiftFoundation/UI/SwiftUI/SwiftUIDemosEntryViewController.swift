import UIKit
import SwiftUI

class SwiftUIDemosEntryViewController: UITableViewController {
    
    private let demos: [(title: String, views: [(String, AnyView)])] = [
        ("BasePractise", [
            ("Example4_TextFieldView", AnyView(Example26_Enviroment())),
        ]),
        
//        ("Login Demo", [
//            ("Combine Login", AnyView(SwiftUILoginDemoView()))
//        ]),
//        ("Navigation Demo", [
//            ("Standard Navigation", AnyView(SwiftUINavigationDemoView()))
//        ]),
//        ("UIKit Integration", [
//            ("UIKit <-> SwiftUI", AnyView(SwiftUIUIKitIntegrationDemoView()))
//        ]),
//        ("Advanced Demos", [
//            ("User Input", AnyView(UserInputDemoView())),
//            ("Animations", AnyView(AnimationDemoView())),
//            ("ViewBuilder", AnyView(ViewBuilderDemoView())),
//            ("AppStorage", AnyView(AppStorageDemoView()))
//        ]),
//        ("Core SwiftUI Demos", [
//            ("@State Demo", AnyView(StateDemoView())),
//            ("@Binding Demo", AnyView(BindingDemoView())),
//            ("@StateObject vs @ObservedObject", AnyView(ObjectDemoView()))
//        ]),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SwiftUI Demos"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return demos.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demos[section].views.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return demos[section].title
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let demo = demos[indexPath.section].views[indexPath.row]
        cell.textLabel?.text = demo.0
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let demo = demos[indexPath.section].views[indexPath.row]
        let hostingController = UIHostingController(rootView: demo.1)
        hostingController.title = demo.0
        navigationController?.pushViewController(hostingController, animated: true)
    }
}
