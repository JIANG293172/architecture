import UIKit
import SnapKit
import Combine

/// 演示 CombineRefreshManager 的防抖效果
class RefreshDemoViewController: UIViewController {

    internal var collectionView: UICollectionView!
    private var dataSource: [Int] = []
    internal var refreshManager = CombineRefreshManager(interval: 0.5) // 设置 0.5 秒防抖
    
    internal let logLabel = UILabel()
    internal var requestCount = 0
    internal var actualRefreshCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRefreshManager()
    }
    
    private func setupUI() {
        title = "Combine 防抖刷新演示"
        view.backgroundColor = .white
        
        // 1. 操作面板
        let panel = UIView()
        panel.backgroundColor = .systemGroupedBackground
        view.addSubview(panel)
        panel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(150)
        }
        
        let btn = UIButton(type: .system)
        btn.setTitle("🔥 模拟高频触发刷新 (连续点击)", for: .normal)
        btn.backgroundColor = .systemRed
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(simulateHighFrequencyRefresh), for: .touchUpInside)
        panel.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(50)
        }
        
        logLabel.numberOfLines = 0
        logLabel.textAlignment = .center
        logLabel.font = .systemFont(ofSize: 14)
        logLabel.text = "请求次数: 0\n实际 reload 次数: 0"
        panel.addSubview(logLabel)
        logLabel.snp.makeConstraints { make in
            make.top.equalTo(btn.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
        }
        
        // 2. CollectionView
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(panel.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func setupRefreshManager() {
        // 绑定刷新动作
        refreshManager.bindRefreshAction { [weak self] in
            self?.performActualReload()
        }
    }
    
    @objc private func simulateHighFrequencyRefresh() {
        requestCount += 1
        updateLog()
        
        // 模拟从任意线程发起请求
        DispatchQueue.global().async {
            self.refreshManager.requestRefresh()
        }
    }
    
    private func performActualReload() {
        actualRefreshCount += 1
        updateLog()
        
        // 模拟数据变化
        dataSource = (0..<20).map { _ in Int.random(in: 10...99) }
        collectionView.reloadData()
        
        // 简单的动画反馈
        collectionView.alpha = 0.5
        UIView.animate(withDuration: 0.3) {
            self.collectionView.alpha = 1.0
        }
    }
    
    private func updateLog() {
        logLabel.text = "请求次数: \(requestCount)\n实际 reload 次数: \(actualRefreshCount)"
    }
}

extension RefreshDemoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .systemBlue
        
        // 移除旧 Label
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let label = UILabel()
        label.text = "\(dataSource[indexPath.item])"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 18)
        cell.contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        return cell
    }
}
