import UIKit

class EnglishInterviewListViewController: UIViewController {
    
    private let tableView = UITableView()
    private let topics: [[String: String]] = [
        ["title": "1. UIViewController Lifecycle (Step-by-Step)", "id": "lifecycle"],
        ["title": "2. Complete Lifecycle Demo (All-in-One)", "id": "complete_vc"]
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
        }
    }
}
