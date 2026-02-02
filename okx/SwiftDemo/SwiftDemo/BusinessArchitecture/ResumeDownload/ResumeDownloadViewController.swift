import UIKit
import DownloadKit // 引入本地 Pod

class ResumeDownloadViewController: UIViewController {
    
    private let urlString = "https://speed.hetzner.de/100MB.bin" // 测试大文件
    private var currentTask: DownloadKit.DownloadTask?
    
    private let progressView = UIProgressView(progressViewStyle: .default)
    private let statusLabel = UILabel()
    private let actionButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "断点续传演示"
        view.backgroundColor = .white
        
        statusLabel.text = "等待下载..."
        statusLabel.textAlignment = .center
        
        progressView.progress = 0
        
        actionButton.setTitle("开始下载", for: .normal)
        actionButton.backgroundColor = .systemBlue
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.layer.cornerRadius = 8
        actionButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
        actionButton.addTarget(self, action: #selector(handleAction), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [statusLabel, progressView, actionButton])
        stack.axis = .vertical
        stack.spacing = 30
        stack.alignment = .fill
        
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
            stack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
            progressView.heightAnchor.constraint(equalToConstant: 4)
        ])
    }
    
    @objc private func handleAction() {
        if currentTask?.status == .downloading {
            DownloadManager.shared.pause(urlString)
            actionButton.setTitle("继续下载", for: .normal)
            statusLabel.text = "已暂停"
        } else {
            startDownload()
            actionButton.setTitle("暂停下载", for: .normal)
        }
    }
    
    private func startDownload() {
        currentTask = DownloadManager.shared.download(urlString)
        
        currentTask?.progressHandler = { [weak self] progress in
            self?.progressView.setProgress(progress.progress, animated: true)
            self?.statusLabel.text = "下载中: \(Int(progress.progress * 100))%"
        }
        
        currentTask?.completionHandler = { [weak self] result in
            switch result {
            case .success(let path):
                self?.statusLabel.text = "✅ 下载成功！"
                self?.actionButton.isEnabled = false
                print("文件路径: \(path.path)")
            case .failure(let error):
                self?.statusLabel.text = "❌ 失败: \(error)"
                self?.actionButton.setTitle("重试", for: .normal)
            }
        }
    }
}
