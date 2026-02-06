import UIKit

class ConcurrentDemoListViewController: UIViewController {
    
    private let tableView = UITableView()
    private let demos: [(title: String, action: () -> Void)] = [
        ("1. Actor (Data Race Protection)", { ActorDemo().runDemo() }),
        ("2. Task & Await (Sequential/Parallel)", { TaskAwaitDemo().runDemo() }),
        ("3. Async Closure to Await (Continuation)", { AsyncClosureDemo().runDemo() }),
        ("4. TaskGroup (Dynamic Child Tasks)", { TaskGroupDemo().runDemo() }),
        ("5. GCD DispatchGroup & OperationQueue", { ClassicConcurrencyDemo().runDemo() }),
        ("6. Modern Concurrency (AsyncStream)", { ModernConcurrencyDemo().runDemo() })
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Modern Concurrency Demos"
        view.backgroundColor = .systemBackground
        setupTableView()
        
        // Add a hint label
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

extension ConcurrentDemoListViewController: UITableViewDelegate, UITableViewDataSource {
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
        print("\n--- Executing: \(demos[indexPath.row].title) ---")
        demos[indexPath.row].action()
        
        let alert = UIAlertController(title: "Demo Started", message: "Execution logs are being printed to the console.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
