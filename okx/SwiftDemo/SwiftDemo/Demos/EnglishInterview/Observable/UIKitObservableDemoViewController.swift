import UIKit
import Observation

// MARK: - ViewModel (MVVM)
/// Using the iOS 17+ @Observable macro.
/// In UIKit, we don't have SwiftUI's automatic body refresh,
/// so we use 'withObservationTracking' to react to changes.
@Observable
class UIKitObservableViewModel {
    // State
    var count: Int = 0
    var items: [String] = ["Initial Item"]
    var isLoading: Bool = false
    
    // Actions
    func increment() {
        count += 1
    }
    
    func addItem() {
        isLoading = true
        // Simulate network/delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.items.append("Item \(self.count)")
            self.isLoading = false
        }
    }
    
    func clearItems() {
        items.removeAll()
        count = 0
    }
}

// MARK: - ViewController
class UIKitObservableDemoViewController: UIViewController {
    
    private let viewModel = UIKitObservableViewModel()
    
    // UI Elements
    private let statusLabel = UILabel()
    private let countLabel = UILabel()
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        
        // Start observation tracking
        observeViewModel()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "UIKit + @Observable (MVVM)"
        
        statusLabel.text = "MVVM with @Observable in UIKit"
        statusLabel.font = .preferredFont(forTextStyle: .headline)
        statusLabel.textAlignment = .center
        
        countLabel.font = .systemFont(ofSize: 24, weight: .bold)
        countLabel.textAlignment = .center
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        
        let incrementButton = UIButton(type: .system)
        incrementButton.setTitle("Increment & Add Item", for: .normal)
        incrementButton.addTarget(self, action: #selector(didTapIncrement), for: .touchUpInside)
        
        let clearButton = UIButton(type: .system)
        clearButton.setTitle("Clear All", for: .normal)
        clearButton.setTitleColor(.systemRed, for: .normal)
        clearButton.addTarget(self, action: #selector(didTapClear), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [statusLabel, countLabel, incrementButton, clearButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            view.safeAreaLayoutGuide.topAnchor.constraint(equalToSystemSpacingBelow: view.subviews[0].topAnchor, multiplier: 2),
            view.subviews[0].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            view.subviews[0].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: view.subviews[0].bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        ])
    }
    
    // MARK: - Observation Logic
    /// In UIKit, withObservationTracking only tracks the *next* change.
    /// To maintain continuous observation, we must re-register the observation
    /// in the onChange handler.
    private func observeViewModel() {
        withObservationTracking {
            // Access the properties we want to track
            // Note: withObservationTracking tracks access to properties
            self.countLabel.text = "Count: \(self.viewModel.count)"
            self.tableView.reloadData()
            
            if self.viewModel.isLoading {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
        } onChange: { [weak self] in
            // This is called on a background thread when a property changes!
            // We need to jump back to main thread to update UI and re-observe.
            DispatchQueue.main.async {
                self?.observeViewModel()
            }
        }
    }
    
    @objc private func didTapIncrement() {
        viewModel.increment()
        viewModel.addItem()
    }
    
    @objc private func didTapClear() {
        viewModel.clearItems()
    }
}

// MARK: - UITableViewDataSource
extension UIKitObservableDemoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = viewModel.items[indexPath.row]
        return cell
    }
}
