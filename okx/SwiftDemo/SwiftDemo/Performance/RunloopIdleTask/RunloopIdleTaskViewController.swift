import UIKit

/// RunLoop 空闲任务视图控制器
/// 思路：演示如何在主线程 RunLoop 空闲时执行轻量级任务
class RunloopIdleTaskViewController: UIViewController {
    
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
    
    /// 开始空闲任务按钮
    private lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("开始空闲任务", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(startIdleTasks), for: .touchUpInside)
        return button
    }()
    
    /// 停止空闲任务按钮
    private lazy var stopButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("停止空闲任务", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(stopIdleTasks), for: .touchUpInside)
        return button
    }()
    
    /// 清空日志按钮
    private lazy var clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("清空日志", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(clearLog), for: .touchUpInside)
        return button
    }()
    
    /// 空闲任务计数器
    private var idleTaskCount: Int = 0
    
    /// RunLoop 空闲观察者
    private var idleObserver: CFRunLoopObserver?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "RunLoop 空闲任务"
        setupUI()
        redirectConsoleLogToTextView()
    }
    
    deinit {
        // 停止空闲任务
        stopIdleTasks()
    }
    
    /// 设置 UI
    private func setupUI() {
        view.backgroundColor = .white
        
        // 添加子视图
        view.addSubview(logTextView)
        view.addSubview(startButton)
        view.addSubview(stopButton)
        view.addSubview(clearButton)
        
        // 设置约束
        logTextView.translatesAutoresizingMaskIntoConstraints = false
        startButton.translatesAutoresizingMaskIntoConstraints = false
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // 日志文本视图
            logTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            logTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            logTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            logTextView.heightAnchor.constraint(equalToConstant: 200),
            
            // 开始按钮
            startButton.topAnchor.constraint(equalTo: logTextView.bottomAnchor, constant: 20),
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            startButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -5),
            startButton.heightAnchor.constraint(equalToConstant: 44),
            
            // 停止按钮
            stopButton.topAnchor.constraint(equalTo: logTextView.bottomAnchor, constant: 20),
            stopButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 5),
            stopButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stopButton.heightAnchor.constraint(equalToConstant: 44),
            
            // 清空按钮
            clearButton.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 20),
            clearButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            clearButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            clearButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    /// 开始在 RunLoop 空闲时执行任务
    @objc private func startIdleTasks() {
        print("开始在 RunLoop 空闲时执行任务")
        
        // 创建 RunLoop 空闲观察者
        idleObserver = CFRunLoopObserverCreateWithHandler(nil, CFRunLoopActivity.beforeWaiting.rawValue, true, 0) { [weak self] (observer, activity) in
            guard let self = self else { return }
            
            // 在主线程空闲时执行任务
            self.performIdleTask()
        }
        
        // 添加观察者到主线程 RunLoop
        if let observer = idleObserver {
            CFRunLoopAddObserver(CFRunLoopGetMain(), observer, CFRunLoopMode.commonModes)
        }
    }
    
    /// 停止 RunLoop 空闲任务
    @objc private func stopIdleTasks() {
        print("停止 RunLoop 空闲任务")
        
        // 移除观察者
        if let observer = idleObserver {
            CFRunLoopRemoveObserver(CFRunLoopGetMain(), observer, CFRunLoopMode.commonModes)
            idleObserver = nil
        }
    }
    
    /// 执行空闲任务
    private func performIdleTask() {
        idleTaskCount += 1
        
        // 模拟轻量级后台任务
        let taskId = idleTaskCount
        print("[空闲任务] 执行第 \(taskId) 个任务")
        
        // 示例：更新日志显示
        DispatchQueue.main.async {
            let timestamp = Date().formatted(date: .numeric, time: .standard)
            self.logTextView.text += "[空闲任务] 执行第 \(taskId) 个任务 - \(timestamp)\n"
            
            // 滚动到末尾
            if !self.logTextView.text.isEmpty {
                let bottom = NSRange(location: self.logTextView.text.count - 1, length: 1)
                self.logTextView.scrollRangeToVisible(bottom)
            }
        }
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
