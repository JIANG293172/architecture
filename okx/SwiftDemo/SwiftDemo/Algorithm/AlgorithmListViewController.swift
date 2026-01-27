import UIKit

class AlgorithmListViewController: ViewController {
    
    // Define algorithm demo list
    private let demoList: [[String: String]] = [
        ["title": "Binary Tree Level Order Traversal", "vcClassName": "LevelOrderTraversalViewController"],
        ["title": "Binary Tree Max Depth", "vcClassName": "MaxDepthViewController"],
        ["title": "Reverse Linked List", "vcClassName": "ReverseListViewController"],
        ["title": "Quick Sort", "vcClassName": "QuickSortViewController"],
        ["title": "Longest Continuous Increasing Subsequence", "vcClassName": "LCISViewController"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Algorithms"
    }
    
    // Override table view data source methods to use custom demoList
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let demoItem = demoList[indexPath.row]
        cell.textLabel?.text = demoItem["title"]
        cell.textLabel?.textColor = .black
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .white
        cell.contentView.backgroundColor = .white
        return cell
    }
    
    // Override didSelectRowAt to use custom demoList
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let demoItem = demoList[indexPath.row]
        guard let vcClassName = demoItem["vcClassName"] else {
            return
        }
        
        // Use runtime to create view controller from class name
        if let vcClass = NSClassFromString("SwiftDemo." + vcClassName) as? UIViewController.Type {
            let targetVC = vcClass.init()
            navigationController?.pushViewController(targetVC, animated: true)
        }
    }
}
