import UIKit

class ArchitectureListViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private let items: [(title: String, subtitle: String, target: UIViewController.Type)] = [
        ("支付组件架构", "支付 SDK 封装与多渠道路由设计", PayDemoViewController.self),
        ("断点续传架构", "大文件下载、状态持久化与断点续传", ResumeDownloadViewController.self),
        ("IM 即时通讯架构", "高性能长连接、消息可靠性与时序性设计", IMDemoViewController.self),
        ("HTTPS 网络架构", "Alamofire 封装、TLS 双向认证、Token 刷新拦截", NetworkDemoViewController.self),
        ("Combine 防抖刷新", "利用 Combine 实现高频 UI 刷新的性能优化", RefreshDemoViewController.self)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "业务架构目录"
        view.backgroundColor = .systemGroupedBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ArchitectureListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.subtitle
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = items[indexPath.row].target.init()
        navigationController?.pushViewController(vc, animated: true)
    }
}
