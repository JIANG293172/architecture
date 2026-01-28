import UIKit
import Darwin

/// RunLoop 卡顿监控视图控制器
/// 思路：展示基于 RunLoop 机制的卡顿检测功能，包括监控启动/停止、卡顿日志显示
class RunloopMonitorViewController: UIViewController {
    
    /// 日志文本视图
    private lazy var logTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.textColor = .black
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isEditable = false
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 8
        return textView
    }()
    
    /// 开始监控按钮
    private lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("开始监控", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(startMonitoring), for: .touchUpInside)
        return button
    }()
    
    /// 停止监控按钮
    private lazy var stopButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("停止监控", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(stopMonitoring), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    /// 模拟卡顿按钮
    private lazy var simulateStutterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("模拟卡顿", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemOrange
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(simulateStutter), for: .touchUpInside)
        return button
    }()
    
    /// 清空日志按钮
    private lazy var clearLogButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("清空日志", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(clearLog), for: .touchUpInside)
        return button
    }()
    
    /// 监控器
    private let monitor = RunloopMonitor.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "RunLoop 卡顿监控"
        setupUI()
        redirectConsoleLogToTextView()
    }
    
    deinit {
        // 停止监控
        monitor.stopMonitoring()
    }
    
    /// 设置 UI
    private func setupUI() {
        view.backgroundColor = .white
        
        // 添加子视图
        view.addSubview(logTextView)
        view.addSubview(startButton)
        view.addSubview(stopButton)
        view.addSubview(simulateStutterButton)
        view.addSubview(clearLogButton)
        
        // 设置约束
        logTextView.translatesAutoresizingMaskIntoConstraints = false
        startButton.translatesAutoresizingMaskIntoConstraints = false
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        simulateStutterButton.translatesAutoresizingMaskIntoConstraints = false
        clearLogButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // 日志文本视图
            logTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            logTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            logTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            logTextView.heightAnchor.constraint(equalToConstant: 300),
            
            // 开始监控按钮
            startButton.topAnchor.constraint(equalTo: logTextView.bottomAnchor, constant: 20),
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            startButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -5),
            startButton.heightAnchor.constraint(equalToConstant: 44),
            
            // 停止监控按钮
            stopButton.topAnchor.constraint(equalTo: logTextView.bottomAnchor, constant: 20),
            stopButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 5),
            stopButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stopButton.heightAnchor.constraint(equalToConstant: 44),
            
            // 模拟卡顿按钮
            simulateStutterButton.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 10),
            simulateStutterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            simulateStutterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            simulateStutterButton.heightAnchor.constraint(equalToConstant: 44),
            
            // 清空日志按钮
            clearLogButton.topAnchor.constraint(equalTo: simulateStutterButton.bottomAnchor, constant: 20),
            clearLogButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            clearLogButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            clearLogButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    /// 开始监控
    @objc private func startMonitoring() {
        startButton.isEnabled = false
        stopButton.isEnabled = true
        
        print("开始 RunLoop 卡顿监控")
        
        // 开始监控
        monitor.startMonitoring { [weak self] duration in
            DispatchQueue.main.async {
                let timestamp = Date().formatted(date: .numeric, time: .standard)
                print("[卡顿] 持续时间: \(String(format: "%.3f", duration))秒 - \(timestamp)")
            }
        }
    }
    
    /// 停止监控
    @objc private func stopMonitoring() {
        startButton.isEnabled = true
        stopButton.isEnabled = false
        
        print("停止 RunLoop 卡顿监控")
        
        // 停止监控
        monitor.stopMonitoring()
    }
    
    /// 模拟卡顿
    @objc private func simulateStutter() {
        print("开始模拟卡顿...")
        
        // 模拟卡顿 200ms
        let start = Date()
        while Date().timeIntervalSince(start) < 0.2 {
            // 空循环，模拟计算密集型任务
        }
        
        print("卡顿模拟结束")
    }
    
    /// 清空日志
    @objc private func clearLog() {
        logTextView.text = ""
    }
    
    /// 重定向控制台日志到文本视图
    private func redirectConsoleLogToTextView() {
        return
        let pipe = Pipe()
        let fileHandle = pipe.fileHandleForReading
        
        // 重定向标准输出
        dup2(pipe.fileHandleForWriting.fileDescriptor, FileHandle.standardOutput.fileDescriptor)
        
        // 重定向标准错误
        dup2(pipe.fileHandleForWriting.fileDescriptor, FileHandle.standardError.fileDescriptor)
        
        // 监听管道数据
        fileHandle.readabilityHandler = { [weak self] handle in
            guard let data = try? handle.readToEnd(),
                  let string = String(data: data, encoding: .utf8) else {
                return
            }
            
            DispatchQueue.main.async {
                self?.logTextView.text += string
                
                // 滚动到末尾
                if let textView = self?.logTextView, !textView.text.isEmpty {
                    let bottom = NSRange(location: textView.text.count - 1, length: 1)
                    textView.scrollRangeToVisible(bottom)
                }
            }
        }
    }
}
