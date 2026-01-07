//
//  ViewController.swift
//  RxSwift02
//
//  Created by CQCA202121101_2 on 2025/11/5.
//


import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    // MARK: - UI Components
    private let tableView = UITableView()
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private let errorLabel = UILabel()
    private let reloadButton = UIButton(type: .system)
    
    // MARK: - Dependencies
    private let viewModel = DealerListViewModel()
    private let disposeBag = DisposeBag() // Manage subscriptions
    private var currentDealers: [DealerModel] = [] // Cache current dealer list
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel() // Bind ViewModel state to UI
        triggerInitialLoad() // Trigger initial data load
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        title = "Dealer List"
        
        // TableView setup
        tableView.register(DealerCell.self, forCellReuseIdentifier: "DealerCell")
        tableView.rowHeight = 100
        tableView.delegate = self
        
        // ErrorLabel setup
        errorLabel.textColor = .red
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true
        
        // ReloadButton setup
        reloadButton.setTitle("Reload Dealer List", for: .normal)
        reloadButton.addTarget(self, action: #selector(reloadButtonTapped), for: .touchUpInside)
        reloadButton.isHidden = true
        
        // LoadingIndicator setup
        loadingIndicator.hidesWhenStopped = true
        
        // Layout (StackView for simplicity)
        let stackView = UIStackView(arrangedSubviews: [loadingIndicator, errorLabel, reloadButton, tableView])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - ViewModel Binding
    private func bindViewModel() {
        // 1. Bind dealer list to TableView
        viewModel.dealerListSubject
            .observe(on: MainScheduler.instance) // Switch to main thread for UI update
            .subscribe(onNext: { [weak self] dealers in
                self?.currentDealers = dealers
                self?.tableView.reloadData()
                self?.updateUIState() // Update UI visibility (error/reload/table)
            })
            .disposed(by: disposeBag)
        
        // 2. Bind loading status to indicator
        viewModel.isLoadingSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                isLoading ? self?.loadingIndicator.startAnimating() : self?.loadingIndicator.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        // 3. Bind error message to label
        viewModel.errorMessageSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] errorMsg in
                self?.errorLabel.text = errorMsg
                self?.updateUIState()
            })
            .disposed(by: disposeBag)
        
        // 4. Bind inquiry result to alert
        viewModel.inquiryResultSubject
            .observe(on: MainScheduler.instance)
            .filter { $0 != nil } // Only react to non-nil results
            .subscribe(onNext: { [weak self] result in
                let alert = UIAlertController(title: "Success", message: result, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - User Actions
    @objc private func reloadButtonTapped() {
        triggerInitialLoad()
    }
    
    private func triggerInitialLoad() {
        viewModel.loadDealerListTrigger.onNext(()) // Emit load trigger
    }
    
    // MARK: - UI State Update
    private func updateUIState() {
        let hasError = viewModel.errorMessageSubject.currentValue() != nil
        let hasDealers = !currentDealers.isEmpty
        
        errorLabel.isHidden = !hasError
        reloadButton.isHidden = !hasError && hasDealers
        tableView.isHidden = hasError || currentDealers.isEmpty
    }
}

// MARK: - TableView DataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currentDealers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DealerCell", for: indexPath) as! DealerCell
        let dealer = currentDealers[indexPath.row]
        cell.configure(with: dealer)
        
        // Bind cell buttons to ViewModel triggers
        cell.callButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.callDealerTrigger.onNext(dealer.phone)
            })
            .disposed(by: cell.disposeBag)
        
        cell.inquiryButton.rx.tap
            .subscribe(onNext: { [weak self] in
                // Simulate user input (replace with real input form in production)
                let inquiryParams = (
                    dealerId: dealer.id,
                    userName: "John Doe",
                    phone: "13800138000",
                    vehicleType: "Changan UNI-V"
                )
                self?.viewModel.submitInquiryTrigger.onNext(inquiryParams)
            })
            .disposed(by: cell.disposeBag)
        
        return cell
    }
}

// MARK: - Custom TableViewCell
class DealerCell: UITableViewCell {
    let nameLabel = UILabel()
    let addressLabel = UILabel()
    let priceLabel = UILabel()
    let authLabel = UILabel()
    let callButton = UIButton(type: .system)
    let inquiryButton = UIButton(type: .system)
    let disposeBag = DisposeBag() // Manage cell-level subscriptions
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCellUI() {
        // Configure labels
        nameLabel.font = .boldSystemFont(ofSize: 16)
        addressLabel.font = .systemFont(ofSize: 14)
        addressLabel.textColor = .gray
        priceLabel.font = .systemFont(ofSize: 14)
        priceLabel.textColor = .orange
        authLabel.font = .systemFont(ofSize: 12)
        authLabel.textColor = .white
        authLabel.backgroundColor = .green
        authLabel.textAlignment = .center
        authLabel.layer.cornerRadius = 4
        authLabel.clipsToBounds = true
        
        // Configure buttons
        callButton.setTitle("Call", for: .normal)
        callButton.tintColor = .blue
        inquiryButton.setTitle("Inquiry", for: .normal)
        inquiryButton.tintColor = .systemGreen
        
        // Layout (StackView for clarity)
        let topStack = UIStackView(arrangedSubviews: [nameLabel, authLabel])
        topStack.spacing = 8
        let infoStack = UIStackView(arrangedSubviews: [addressLabel, priceLabel])
        infoStack.axis = .vertical
        infoStack.spacing = 4
        let buttonStack = UIStackView(arrangedSubviews: [callButton, inquiryButton])
        buttonStack.spacing = 12
        
        let mainStack = UIStackView(arrangedSubviews: [topStack, infoStack, buttonStack])
        mainStack.axis = .vertical
        mainStack.spacing = 8
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            authLabel.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    /// Configure cell with dealer data
    func configure(with dealer: DealerModel) {
        nameLabel.text = dealer.name
        addressLabel.text = dealer.address
        priceLabel.text = String(format: "Starting Price: ¥%.0f", dealer.minPrice)
        authLabel.text = dealer.isAuthorized ? "Authorized" : "Unauthorized"
        authLabel.backgroundColor = dealer.isAuthorized ? .systemGreen : .systemGray
    }
}
