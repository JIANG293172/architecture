import UIKit
import SwiftUI

class EnglishInterviewListViewController: UIViewController {
    
    private let tableView = UITableView()
    private let topics: [[String: String]] = [
        ["title": "1. UIViewController Lifecycle (Step-by-Step)", "id": "lifecycle"],
        ["title": "2. Complete Lifecycle Demo (All-in-One)", "id": "complete_vc"],
        ["title": "3. Combine Framework Demos (131-150)", "id": "combine"],
        ["title": "4. SwiftUI Interview Demos (76-100)", "id": "swiftui"],
        ["title": "5. Modern Concurrency Demos (Actor, Task)", "id": "concurrent"],
        ["title": "6. Classical Concurrency Demos (GCD, NSOperation)", "id": "classical_concurrent"],
        ["title": "7. Swift Language Demos (50 Examples)", "id": "swift_lang"],
        ["title": "8. iOS 17/18 Observation Framework Demo", "id": "observable"],
        ["title": "9. UIKit + @Observable (MVVM) Demo", "id": "uikit_observable"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "English Interview Demos"
        view.backgroundColor = .systemBackground
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension EnglishInterviewListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = topics[indexPath.row]["title"]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let topicId = topics[indexPath.row]["id"]
        
        if topicId == "lifecycle" {
            let vc = LifecycleStepViewController(stepId: "init")
            navigationController?.pushViewController(vc, animated: true)
        } else if topicId == "complete_vc" {
            let vc = CompleteVC(vcType: "Programmatic", customData: "Full Lifecycle Test")
            navigationController?.pushViewController(vc, animated: true)
        } else if topicId == "combine" {
            let vc = CombineDemoListViewController()
            navigationController?.pushViewController(vc, animated: true)
        } else if topicId == "swiftui" {
            let swiftUIView = SwiftUIDemoListView()
            let hostingController = UIHostingController(rootView: swiftUIView)
            hostingController.title = "SwiftUI Demos"
            navigationController?.pushViewController(hostingController, animated: true)
        } else if topicId == "concurrent" {
            let vc = ConcurrentDemoListViewController()
            navigationController?.pushViewController(vc, animated: true)
        } else if topicId == "classical_concurrent" {
            let vc = ClassicalConcurrencyListViewController()
            navigationController?.pushViewController(vc, animated: true)
        } else if topicId == "swift_lang" {
            let vc = SwiftLanguageDemoListViewController()
            navigationController?.pushViewController(vc, animated: true)
        } else if topicId == "observable" {
            let view = ObservableDemoView()
            let vc = UIHostingController(rootView: view)
            vc.title = "Observation Framework"
            navigationController?.pushViewController(vc, animated: true)
        } else if topicId == "uikit_observable" {
            let vc = UIKitObservableDemoViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
