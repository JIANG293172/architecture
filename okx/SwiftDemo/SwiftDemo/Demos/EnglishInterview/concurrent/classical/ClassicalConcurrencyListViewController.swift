import UIKit

class ClassicalConcurrencyListViewController: UIViewController {
    
    private let tableView = UITableView()
    private let demos: [(title: String, action: () -> Void)] = [
        ("1. GCD Advanced (Timer, Barrier, Semaphore)", { GCDDemo().runDemo() }),
        ("2. NSOperation (Dependency, Limit, Custom)", { NSOperationDemo().runDemo() }),
        ("3. NSThread (Manual, NSLock)", { NSThreadDemo().runDemo() }),
        ("4. GCD Group & OperationQueue (Basic)", { ClassicConcurrencyDemo().runDemo() })
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Classical Concurrency Demos"
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

extension ClassicalConcurrencyListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = demos[indexPath.row].title
        cell.accessoryType = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("\n--- Executing Classical Demo: \(demos[indexPath.row].title) ---")
        demos[indexPath.row].action()
        
        let alert = UIAlertController(title: "Classical Demo Started", message: "Execution logs are being printed to the console.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
