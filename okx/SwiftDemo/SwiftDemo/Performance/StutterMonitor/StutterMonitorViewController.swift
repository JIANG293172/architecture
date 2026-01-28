import UIKit

/// 卡顿检测演示视图控制器
class StutterMonitorViewController: UIViewController {
    
    /// 启动监控按钮
    private let startButton = UIButton(type: .system)
    /// 停止监控按钮
    private let stopButton = UIButton(type: .system)
    /// 模拟卡顿按钮
    private let simulateStutterButton = UIButton(type: .system)
    /// 监控状态标签
    private let statusLabel = UILabel()
    /// 日志文本视图
    private let logTextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Stutter Monitor"
        view.backgroundColor = .white
        setupUI()
    }
    
    /// 设置用户界面
    private func setupUI() {
        // 设置状态标签
        statusLabel.frame = CGRect(x: 50, y: 100, width: view.frame.width - 100, height: 40)
        statusLabel.textAlignment = .center
        statusLabel.font = UIFont.systemFont(ofSize: 18)
        statusLabel.textColor = .black
        statusLabel.text = "监控状态：未启动"
        view.addSubview(statusLabel)
        
        // 设置启动按钮
        startButton.frame = CGRect(x: 50, y: 160, width: view.frame.width - 100, height: 44)
        startButton.setTitle("启动卡顿检测", for: .normal)
        startButton.setTitleColor(.white, for: .normal)
        startButton.backgroundColor = .systemGreen
        startButton.layer.cornerRadius = 22
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        view.addSubview(startButton)
        
        // 设置停止按钮
        stopButton.frame = CGRect(x: 50, y: 220, width: view.frame.width - 100, height: 44)
        stopButton.setTitle("停止卡顿检测", for: .normal)
        stopButton.setTitleColor(.white, for: .normal)
        stopButton.backgroundColor = .systemRed
        stopButton.layer.cornerRadius = 22
        stopButton.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
        view.addSubview(stopButton)
        
        // 设置模拟卡顿按钮
        simulateStutterButton.frame = CGRect(x: 50, y: 280, width: view.frame.width - 100, height: 44)
        simulateStutterButton.setTitle("模拟卡顿", for: .normal)
        simulateStutterButton.setTitleColor(.white, for: .normal)
        simulateStutterButton.backgroundColor = .systemOrange
        simulateStutterButton.layer.cornerRadius = 22
        simulateStutterButton.addTarget(self, action: #selector(simulateStutterButtonTapped), for: .touchUpInside)
        view.addSubview(simulateStutterButton)
        
        // 设置日志文本视图
        logTextView.frame = CGRect(x: 50, y: 340, width: view.frame.width - 100, height: 300)
        logTextView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        logTextView.textColor = .black
        logTextView.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)
        logTextView.isEditable = false
        logTextView.layer.borderWidth = 1.0
        logTextView.layer.borderColor = UIColor.gray.cgColor
        logTextView.layer.cornerRadius = 8.0
        logTextView.text = "日志输出：\n"
        view.addSubview(logTextView)
        
        // 配置日志重定向
        redirectConsoleLogToTextView()
    }
    
    /// 启动按钮点击事件
    @objc private func startButtonTapped() {
        StutterMonitor.shared.startMonitor()
        updateStatusLabel(isMonitoring: true)
        appendLog("已启动卡顿检测")
    }
    
    /// 停止按钮点击事件
    @objc private func stopButtonTapped() {
        StutterMonitor.shared.stopMonitor()
        updateStatusLabel(isMonitoring: false)
        appendLog("已停止卡顿检测")
    }
    
    /// 模拟卡顿按钮点击事件
    @objc private func simulateStutterButtonTapped() {
        appendLog("开始模拟卡顿...")
        
        // 模拟卡顿：主线程睡眠 200ms
        DispatchQueue.main.async {
            let startDate = Date()
            // 模拟卡顿操作
            while Date().timeIntervalSince(startDate) < 0.2 {
                // 空循环，占用主线程
            }
            self.appendLog("模拟卡顿结束")
        }
    }
    
    /// 更新状态标签
    private func updateStatusLabel(isMonitoring: Bool) {
        if isMonitoring {
            statusLabel.text = "监控状态：运行中"
            statusLabel.textColor = .systemGreen
        } else {
            statusLabel.text = "监控状态：未启动"
            statusLabel.textColor = .black
        }
    }
    
    /// 追加日志到文本视图
    private func appendLog(_ log: String) {
        DispatchQueue.main.async {
            let timestamp = self.getCurrentTimestamp()
            self.logTextView.text += "[\(timestamp)] \(log)\n"
            // 滚动到底部
            let bottom = NSMakeRange(self.logTextView.text.count - 1, 1)
            self.logTextView.scrollRangeToVisible(bottom)
        }
    }
    
    /// 获取当前时间戳
    private func getCurrentTimestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter.string(from: Date())
    }
    
    /// 重定向控制台日志到文本视图
    private func redirectConsoleLogToTextView() {
        let pipe = Pipe()
        let fileHandle = pipe.fileHandleForReading
        
        dup2(pipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)
        dup2(pipe.fileHandleForWriting.fileDescriptor, STDERR_FILENO)
        
        fileHandle.readabilityHandler = { [weak self] handle in
            let data = handle.availableData
            if let string = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    self?.logTextView.text += string
                    // 滚动到底部
                    let bottom = NSMakeRange((self?.logTextView.text.count ?? 0) - 1, 1)
                    self?.logTextView.scrollRangeToVisible(bottom)
                }
            }
        }
    }
}
