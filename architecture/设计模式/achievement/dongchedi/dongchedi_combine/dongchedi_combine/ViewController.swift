//
//  ViewController.swift
//  dongchedi_combine
//
//  Created by CQCA202121101_2 on 2025/12/17.
//

import UIKit
import Combine

class ViewController: UIViewController {
    // MARK: - UI 组件
    private let tableView = UITableView()
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private let errorLabel = UILabel()
    private let inquiryResultLabel = UILabel()
    
    // MARK: - 依赖注入 ViewModel
    private let viewModel = DealerListViewModel.init()
    private var cancellables = Set<AnyCancellable>()
    
//    init(viewModel: DealerListViewModel = DealerListViewModel()) {
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel() // 订阅 ViewModel 的 Subject
        triggerLoadDealers() // 触发加载
    }
}

// MARK: - UI 布局
extension ViewController {
    private func setupUI() {
        view.backgroundColor = .white
        title = "经销商询价系统"
        
        // TableView 配置
        tableView.register(DealerCell.self, forCellReuseIdentifier: "DealerCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        
        // 错误提示标签
        errorLabel.textColor = .red
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true
        
        // 询价结果标签
        inquiryResultLabel.textColor = .systemGreen
        errorLabel.numberOfLines = 0
        inquiryResultLabel.isHidden = true
        
        // 加载指示器
        loadingIndicator.hidesWhenStopped = true
        
        // 布局
        let stackView = UIStackView(arrangedSubviews: [errorLabel, inquiryResultLabel, tableView])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - 核心：绑定 ViewModel 的 CurrentValueSubject（无需延迟刷新）
extension ViewController {
    private func bindViewModel() {
        // 1. 绑定「加载状态」→ 控制指示器
        viewModel.isLoadingSubject
            .sink(receiveValue: { [weak self] isLoading in
                isLoading ? self?.loadingIndicator.startAnimating() : self?.loadingIndicator.stopAnimating()
            })
            .store(in: &cancellables)
        
        // 2. 绑定「经销商列表」→ 刷新 TableView（数据已就绪，直接刷新）
        viewModel.dealerListSubject
            .sink(receiveValue: { [weak self] _ in
                self?.tableView.reloadData()
                print("View 刷新列表，数据量：\(self?.viewModel.dealerList.count ?? 0)")
            })
            .store(in: &cancellables)
        
        // 3. 绑定「错误信息」→ 显示标签
        viewModel.errorMessageSubject
            .sink(receiveValue: { [weak self] message in
                self?.errorLabel.text = message
                self?.errorLabel.isHidden = message == nil
            })
            .store(in: &cancellables)
        
        // 4. 绑定「询价结果」→ 显示标签
        viewModel.inquiryResultSubject
            .sink(receiveValue: { [weak self] result in
                self?.inquiryResultLabel.text = result
                self?.inquiryResultLabel.isHidden = result == nil
                if result != nil {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self?.inquiryResultLabel.isHidden = true
                    }
                }
            })
            .store(in: &cancellables)
    }
    
    // 触发加载经销商列表
    private func triggerLoadDealers() {
        viewModel.loadDealerListSubject.send()
    }
    
    // 触发提交询价
    private func triggerSubmitInquiry(dealerId: String, userName: String, phone: String, vehicleType: String) {
        viewModel.submitInquirySubject.send((dealerId, userName, phone, vehicleType))
    }
    
    // 触发拨打经销商电话
    private func triggerCallDealer(phone: String) {
        viewModel.callDealerSubject.send(phone)
    }
}

// MARK: - TableView 数据源/代理
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.dealerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DealerCell", for: indexPath) as! DealerCell
        let dealer = viewModel.dealerList[indexPath.row]
        cell.configure(with: dealer)
        
        // 绑定询价按钮点击事件
        cell.inquiryButtonTapped = { [weak self] in
            let userName = "测试用户"
            let userPhone = "13800138000"
            let vehicleType = dealer.mainVehicleType
            self?.triggerSubmitInquiry(
                dealerId: dealer.id,
                userName: userName,
                phone: userPhone,
                vehicleType: vehicleType
            )
        }
        
        // 绑定电话按钮点击事件
        cell.callButtonTapped = { [weak self] in
            self?.triggerCallDealer(phone: dealer.phone)
        }
        
        return cell
    }
}

// MARK: - 自定义 TableViewCell
class DealerCell: UITableViewCell {
    var inquiryButtonTapped: (() -> Void)?
    var callButtonTapped: (() -> Void)?
    
    // UI 组件
    private let nameLabel = UILabel()
    private let addressLabel = UILabel()
    private let vehicleTypeLabel = UILabel()
    private let priceLabel = UILabel()
    private let authorizedLabel = UILabel()
    private let inquiryButton = UIButton(type: .system)
    private let callButton = UIButton(type: .system)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with dealer: DealerModel) {
        nameLabel.text = dealer.name
        addressLabel.text = dealer.address
        vehicleTypeLabel.text = "主营：\(dealer.mainVehicleType)"
        priceLabel.text = String(format: "最低报价：%.2f 万元", dealer.minPrice)
        authorizedLabel.text = dealer.isAuthorized ? "官方授权" : "普通经销商"
        authorizedLabel.textColor = dealer.isAuthorized ? .systemBlue : .gray
        
        inquiryButton.setTitle("提交询价", for: .normal)
        callButton.setTitle("拨打咨询", for: .normal)
    }
}

// MARK: - Cell UI 布局
extension DealerCell {
    private func setupCellUI() {
        // 标签样式
        nameLabel.font = .boldSystemFont(ofSize: 16)
        addressLabel.font = .systemFont(ofSize: 12)
        addressLabel.textColor = .gray
        vehicleTypeLabel.font = .systemFont(ofSize: 13)
        priceLabel.font = .systemFont(ofSize: 13, weight: .medium)
        priceLabel.textColor = .systemRed
        authorizedLabel.font = .systemFont(ofSize: 11)
        authorizedLabel.layer.borderWidth = 1
        authorizedLabel.layer.borderColor = UIColor.systemBlue.cgColor
        authorizedLabel.layer.cornerRadius = 4
        authorizedLabel.textAlignment = .center
        
        // 按钮样式
        inquiryButton.backgroundColor = .systemGreen
        inquiryButton.setTitleColor(.white, for: .normal)
        inquiryButton.layer.cornerRadius = 4
        callButton.backgroundColor = .systemBlue
        callButton.setTitleColor(.white, for: .normal)
        callButton.layer.cornerRadius = 4
        
        // 绑定按钮点击
        inquiryButton.addTarget(self, action: #selector(inquiryButtonAction), for: .touchUpInside)
        callButton.addTarget(self, action: #selector(callButtonAction), for: .touchUpInside)
        
        // 布局
        let contentStack = UIStackView(arrangedSubviews: [
            createTopStack(),
            createMiddleStack(),
            createBottomStack()
        ])
        contentStack.axis = .vertical
        contentStack.spacing = 8
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contentStack)
        
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    private func createTopStack() -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [nameLabel, authorizedLabel])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        authorizedLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        return stack
    }
    
    private func createMiddleStack() -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [addressLabel, vehicleTypeLabel])
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }
    
    private func createBottomStack() -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [priceLabel, inquiryButton, callButton])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillEqually
        return stack
    }
    
    @objc private func inquiryButtonAction() {
        inquiryButtonTapped?()
    }
    
    @objc private func callButtonAction() {
        callButtonTapped?()
    }
}


