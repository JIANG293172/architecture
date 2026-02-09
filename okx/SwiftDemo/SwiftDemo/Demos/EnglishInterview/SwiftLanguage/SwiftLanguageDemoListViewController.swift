import UIKit

class SwiftLanguageDemoListViewController: UIViewController {
    
    private let tableView = UITableView()
    private let examples = SwiftLanguageExamples.shared.getAllExamples()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Swift Language (50 Examples)"
        view.backgroundColor = .systemBackground
        setupTableView()
        
        let hintLabel = UILabel()
        hintLabel.text = "Check console for execution logs"
        hintLabel.textAlignment = .center
        hintLabel.textColor = .secondaryLabel
        hintLabel.font = .systemFont(ofSize: 14)
        hintLabel.frame = CGRect(x: 0, y: view.bounds.height - 100, width: view.bounds.width, height: 40)
        view.addSubview(hintLabel)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension SwiftLanguageDemoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return examples.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let example = examples[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = example.title
        content.secondaryText = example.explanation
        cell.contentConfiguration = content
        
        cell.accessoryType = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let example = examples[indexPath.row]
        
        print("\n--- Executing Swift Example: \(example.title) ---")
        print("Explanation: \(example.explanation)")
        example.action()
        
        let alert = UIAlertController(title: "Example Executed", 
                                    message: "Topic: \(example.title)\n\nCheck console for logs.", 
                                    preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
