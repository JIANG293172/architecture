//
//  Demo4ViewController.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/23.
//

import UIKit
import Foundation

class ResumeDownloadViewController: UIViewController {
    
    // MARK: - UI 控件
    private let urlTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "输入下载链接"
        textField.borderStyle = .roundedRect
        textField.text = "https://dldir1.qq.com/qqfile/qq/QQNT/Windows/QQNT_7.0.0.2934_x64.exe"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("开始下载", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let pauseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("暂停下载", for: .normal)
        button.backgroundColor = .systemOrange
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let resumeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("恢复下载", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progress = 0
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "准备就绪"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let speedLabel: UILabel = {
        let label = UILabel()
        label.text = "下载速度: 0 KB/s"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - 下载管理器
    private var downloadManager: DownloadManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "断点续传示例"
        
        setupUI()
        setupActions()
        
        // 初始化下载管理器
        downloadManager = DownloadManager(delegate: self)
    }
    
    private func setupUI() {
        view.addSubview(urlTextField)
        view.addSubview(startButton)
        view.addSubview(pauseButton)
        view.addSubview(resumeButton)
        view.addSubview(progressView)
        view.addSubview(statusLabel)
        view.addSubview(speedLabel)
        
        NSLayoutConstraint.activate([
            // URL输入框
            urlTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            urlTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            urlTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            urlTextField.heightAnchor.constraint(equalToConstant: 44),
            
            // 按钮水平排列
            startButton.topAnchor.constraint(equalTo: urlTextField.bottomAnchor, constant: 20),
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            startButton.widthAnchor.constraint(equalToConstant: 100),
            startButton.heightAnchor.constraint(equalToConstant: 44),
            
            pauseButton.topAnchor.constraint(equalTo: urlTextField.bottomAnchor, constant: 20),
            pauseButton.leadingAnchor.constraint(equalTo: startButton.trailingAnchor, constant: 10),
            pauseButton.widthAnchor.constraint(equalToConstant: 100),
            pauseButton.heightAnchor.constraint(equalToConstant: 44),
            
            resumeButton.topAnchor.constraint(equalTo: urlTextField.bottomAnchor, constant: 20),
            resumeButton.leadingAnchor.constraint(equalTo: pauseButton.trailingAnchor, constant: 10),
            resumeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            resumeButton.heightAnchor.constraint(equalToConstant: 44),
            
            // 进度条
            progressView.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 30),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // 状态标签
            statusLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 20),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // 速度标签
            speedLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 10),
            speedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            speedLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    private func setupActions() {
        startButton.addTarget(self, action: #selector(startDownload), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(pauseDownload), for: .touchUpInside)
        resumeButton.addTarget(self, action: #selector(resumeDownload), for: .touchUpInside)
    }
    
    @objc private func startDownload() {
        guard let urlString = urlTextField.text, let url = URL(string: urlString) else {
            statusLabel.text = "请输入有效的下载链接"
            return
        }
        
        statusLabel.text = "开始下载..."
        startButton.isEnabled = false
        pauseButton.isEnabled = true
        resumeButton.isEnabled = false
        
        downloadManager?.startDownload(url: url)
    }
    
    @objc private func pauseDownload() {
        statusLabel.text = "暂停下载"
        startButton.isEnabled = false
        pauseButton.isEnabled = false
        resumeButton.isEnabled = true
        
        downloadManager?.pauseDownload()
    }
    
    @objc private func resumeDownload() {
        statusLabel.text = "恢复下载..."
        startButton.isEnabled = false
        pauseButton.isEnabled = true
        resumeButton.isEnabled = false
        
        downloadManager?.resumeDownload()
    }
}

// MARK: - 下载管理器代理
extension Demo4ViewController: DownloadManagerDelegate {
    func downloadProgress(_ progress: Float, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64, speed: String) {
        DispatchQueue.main.async {
            self.progressView.progress = progress
            self.speedLabel.text = "下载速度: \(speed)"
            
            let downloaded = ByteCountFormatter.string(fromByteCount: totalBytesWritten, countStyle: .file)
            let total = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: .file)
            self.statusLabel.text = "下载中: \(downloaded) / \(total)"
        }
    }
    
    func downloadCompleted() {
        DispatchQueue.main.async {
            self.statusLabel.text = "下载完成"
            self.startButton.isEnabled = true
            self.pauseButton.isEnabled = false
            self.resumeButton.isEnabled = false
        }
    }
    
    func downloadFailed(error: Error) {
        DispatchQueue.main.async {
            self.statusLabel.text = "下载失败: \(error.localizedDescription)"
            self.startButton.isEnabled = true
            self.pauseButton.isEnabled = false
            self.resumeButton.isEnabled = false
        }
    }
    
    func downloadPaused() {
        DispatchQueue.main.async {
            self.statusLabel.text = "下载已暂停"
        }
    }
}

// MARK: - 下载管理器（基于 Range 请求的断点续传）
protocol DownloadManagerDelegate: AnyObject {
    func downloadProgress(_ progress: Float, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64, speed: String)
    func downloadCompleted()
    func downloadFailed(error: Error)
    func downloadPaused()
}

class DownloadManager: NSObject {
    weak var delegate: DownloadManagerDelegate?
    
    private var session: URLSession?
    private var downloadTask: URLSessionDataTask?
    private var downloadURL: URL?
    private var tempFileURL: URL?
    private var fileHandle: FileHandle?
    private var totalBytesWritten: Int64 = 0
    private var totalBytesExpectedToWrite: Int64 = 0
    
    // 下载状态
    private var isDownloading = false
    private var isPaused = false
    
    // 速度计算
    private var lastBytesWritten: Int64 = 0
    private var lastTimestamp: TimeInterval = 0
    
    // 多级缓存
    private let cacheManager = DownloadCacheManager()
    
    init(delegate: DownloadManagerDelegate) {
        self.delegate = delegate
        super.init()
        setupSession()
    }
    
    private func setupSession() {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }
    
    func startDownload(url: URL) {
        downloadURL = url
        isDownloading = true
        isPaused = false
        
        // 获取缓存的下载进度
        let cachedProgress = cacheManager.getDownloadProgress(forURL: url)
        totalBytesWritten = cachedProgress.bytesWritten
        totalBytesExpectedToWrite = cachedProgress.totalBytesExpected
        
        // 准备临时文件
        tempFileURL = getTempFileURL(for: url)
        
        do {
            // 检查临时文件是否存在
            if FileManager.default.fileExists(atPath: tempFileURL!.path) {
                // 打开现有文件用于追加
                fileHandle = try FileHandle(forWritingTo: tempFileURL!)
                try fileHandle?.seekToEnd()
            } else {
                // 创建新文件
                let tempDir = tempFileURL!.deletingLastPathComponent()
                try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
                FileManager.default.createFile(atPath: tempFileURL!.path, contents: nil)
                fileHandle = try FileHandle(forWritingTo: tempFileURL!)
            }
        } catch {
            delegate?.downloadFailed(error: error)
            return
        }
        
        // 创建带 Range 的请求
        var request = URLRequest(url: url)
        if totalBytesWritten > 0 {
            request.addValue("bytes=\(totalBytesWritten)-", forHTTPHeaderField: "Range")
            print("恢复下载，从 \(totalBytesWritten) 字节开始")
        }
        
        downloadTask = session?.dataTask(with: request)
        downloadTask?.resume()
        
        // 记录开始时间
        lastTimestamp = Date.timeIntervalSinceReferenceDate
    }
    
    func pauseDownload() {
        guard let task = downloadTask else { return }
        
        task.cancel()
        downloadTask = nil
        
        // 关闭文件句柄
        fileHandle?.closeFile()
        fileHandle = nil
        
        // 保存下载进度
        if let url = downloadURL {
            cacheManager.saveDownloadProgress(forURL: url, bytesWritten: totalBytesWritten, totalBytesExpected: totalBytesExpectedToWrite)
        }
        
        isPaused = true
        isDownloading = false
        delegate?.downloadPaused()
    }
    
    func resumeDownload() {
        guard let url = downloadURL else { return }
        startDownload(url: url)
    }
    
    func cancelDownload() {
        downloadTask?.cancel()
        downloadTask = nil
        
        // 关闭文件句柄
        fileHandle?.closeFile()
        fileHandle = nil
        
        // 清理缓存和临时文件
        if let url = downloadURL {
            cacheManager.removeDownloadProgress(forURL: url)
            cacheManager.removeTempFile(forURL: url)
        }
        
        isDownloading = false
        isPaused = false
    }
    
    private func getTempFileURL(for url: URL) -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let tempDir = documentsDirectory.appendingPathComponent("DownloadTemp")
        let fileName = url.lastPathComponent + ".tmp"
        return tempDir.appendingPathComponent(fileName)
    }
    
    private func getDestinationURL(for url: URL) -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = url.lastPathComponent
        return documentsDirectory.appendingPathComponent(fileName)
    }
    
    private func formatSpeed(_ bytesPerSecond: Int64) -> String {
        if bytesPerSecond < 1024 {
            return "\(bytesPerSecond) B/s"
        } else if bytesPerSecond < 1024 * 1024 {
            return "\(String(format: "%.1f", Double(bytesPerSecond) / 1024)) KB/s"
        } else {
            return "\(String(format: "%.1f", Double(bytesPerSecond) / (1024 * 1024))) MB/s"
        }
    }
}

// MARK: - URLSessionDataDelegate
extension DownloadManager: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        guard let httpResponse = response as? HTTPURLResponse else {
            completionHandler(.cancel)
            return
        }
        
        // 处理 206 Partial Content 和 200 OK
        if httpResponse.statusCode == 206 {
            // 断点续传，使用现有文件
            print("收到 206 Partial Content 响应，继续下载")
        } else if httpResponse.statusCode == 200 && totalBytesWritten == 0 {
            // 全新下载
            print("收到 200 OK 响应，开始新下载")
        } else if httpResponse.statusCode == 200 && totalBytesWritten > 0 {
            // 服务器不支持 Range 请求，重新开始下载
            print("服务器不支持 Range 请求，重新开始下载")
            totalBytesWritten = 0
            totalBytesExpectedToWrite = 0
            
            // 重新创建临时文件
            if let tempURL = tempFileURL {
                try? FileManager.default.removeItem(at: tempURL)
                FileManager.default.createFile(atPath: tempURL.path, contents: nil)
                fileHandle = try? FileHandle(forWritingTo: tempURL)
            }
        } else {
            // 其他错误
            completionHandler(.cancel)
            delegate?.downloadFailed(error: NSError(domain: "DownloadError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP Error \(httpResponse.statusCode)"]))
            return
        }
        
        // 获取文件总大小
        if totalBytesExpectedToWrite == 0 {
            totalBytesExpectedToWrite = response.expectedContentLength
        }
        
        completionHandler(.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        // 写入数据到临时文件
        fileHandle?.write(data)
        totalBytesWritten += Int64(data.count)
        
        // 计算下载进度
        let progress = totalBytesExpectedToWrite > 0 ? Float(totalBytesWritten) / Float(totalBytesExpectedToWrite) : 0
        
        // 计算下载速度
        let currentTimestamp = Date.timeIntervalSinceReferenceDate
        let timeElapsed = currentTimestamp - lastTimestamp
        
        if timeElapsed > 0 {
            let bytesPerSecond = Int64(Double(data.count) / timeElapsed)
            let speed = formatSpeed(bytesPerSecond)
            
            delegate?.downloadProgress(progress, totalBytesWritten: totalBytesWritten, totalBytesExpectedToWrite: totalBytesExpectedToWrite, speed: speed)
            
            // 更新记录
            lastBytesWritten = totalBytesWritten
            lastTimestamp = currentTimestamp
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        // 关闭文件句柄
        fileHandle?.closeFile()
        fileHandle = nil
        
        if let error = error {
            // 处理错误
            if let urlError = error as? URLError {
                switch urlError.code {
                case .cancelled:
                    // 用户主动取消，不算错误
                    break
                default:
                    delegate?.downloadFailed(error: error)
                }
            } else {
                delegate?.downloadFailed(error: error)
            }
            
            isDownloading = false
            return
        }
        
        // 下载完成，移动文件到目标位置
        guard let url = downloadURL, let tempURL = tempFileURL else {
            delegate?.downloadFailed(error: NSError(domain: "DownloadError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing download information"]))
            return
        }
        
        let destinationURL = getDestinationURL(for: url)
        
        do {
            // 确保目标目录存在
            let destinationDir = destinationURL.deletingLastPathComponent()
            try FileManager.default.createDirectory(at: destinationDir, withIntermediateDirectories: true)
            
            // 删除已存在的文件
            if FileManager.default.fileExists(atPath: destinationURL.path) {
                try FileManager.default.removeItem(at: destinationURL)
            }
            
            // 移动文件
            try FileManager.default.moveItem(at: tempURL, to: destinationURL)
            
            // 清理缓存
            cacheManager.removeDownloadProgress(forURL: url)
            cacheManager.removeTempFile(forURL: url)
            
            delegate?.downloadCompleted()
        } catch {
            delegate?.downloadFailed(error: error)
        }
        
        isDownloading = false
        isPaused = false
    }
}

// MARK: - 多级缓存管理器（增强版）
class DownloadCacheManager {
    // 缓存目录
    private let cacheDirectory: URL
    private let progressDirectory: URL
    private let tempFileDirectory: URL
    
    init() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        cacheDirectory = documentsDirectory.appendingPathComponent("DownloadCache")
        progressDirectory = cacheDirectory.appendingPathComponent("Progress")
        tempFileDirectory = cacheDirectory.appendingPathComponent("TempFiles")
        
        // 创建目录
        createDirectories()
    }
    
    private func createDirectories() {
        do {
            try FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
            try FileManager.default.createDirectory(at: progressDirectory, withIntermediateDirectories: true)
            try FileManager.default.createDirectory(at: tempFileDirectory, withIntermediateDirectories: true)
        } catch {
            print("创建缓存目录失败: \(error)")
        }
    }
    
    // 下载进度模型
    struct DownloadProgress {
        let bytesWritten: Int64
        let totalBytesExpected: Int64
    }
    
    // 保存下载进度
    func saveDownloadProgress(forURL url: URL, bytesWritten: Int64, totalBytesExpected: Int64) {
        let fileName = getFileName(fromURL: url)
        let fileURL = progressDirectory.appendingPathComponent(fileName)
        
        let progressDict: [String: Any] = [
            "bytesWritten": bytesWritten,
            "totalBytesExpected": totalBytesExpected,
            "timestamp": Date.timeIntervalSinceReferenceDate
        ]
        
        do {
            let data = try JSONSerialization.data(withJSONObject: progressDict)
            try data.write(to: fileURL)
        } catch {
            print("保存下载进度失败: \(error)")
        }
    }
    
    // 获取下载进度
    func getDownloadProgress(forURL url: URL) -> DownloadProgress {
        let fileName = getFileName(fromURL: url)
        let fileURL = progressDirectory.appendingPathComponent(fileName)
        
        do {
            let data = try Data(contentsOf: fileURL)
            if let progressDict = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                let bytesWritten = (progressDict["bytesWritten"] as? Int64) ?? 0
                let totalBytesExpected = (progressDict["totalBytesExpected"] as? Int64) ?? 0
                return DownloadProgress(bytesWritten: bytesWritten, totalBytesExpected: totalBytesExpected)
            }
        } catch {
            // 没有缓存的进度，返回初始值
        }
        
        return DownloadProgress(bytesWritten: 0, totalBytesExpected: 0)
    }
    
    // 删除下载进度
    func removeDownloadProgress(forURL url: URL) {
        let fileName = getFileName(fromURL: url)
        let fileURL = progressDirectory.appendingPathComponent(fileName)
        
        do {
            if FileManager.default.fileExists(atPath: fileURL.path) {
                try FileManager.default.removeItem(at: fileURL)
            }
        } catch {
            print("删除下载进度失败: \(error)")
        }
    }
    
    // 删除临时文件
    func removeTempFile(forURL url: URL) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let tempDir = documentsDirectory.appendingPathComponent("DownloadTemp")
        let fileName = url.lastPathComponent + ".tmp"
        let fileURL = tempDir.appendingPathComponent(fileName)
        
        do {
            if FileManager.default.fileExists(atPath: fileURL.path) {
                try FileManager.default.removeItem(at: fileURL)
            }
        } catch {
            print("删除临时文件失败: \(error)")
        }
    }
    
    // 从URL生成文件名（使用MD5哈希避免冲突）
    private func getFileName(fromURL url: URL) -> String {
        let urlString = url.absoluteString
        let hash = urlString.md5
        return "\(hash).progress"
    }
}

// MARK: - String MD5 扩展
extension String {
    var md5: String {
        let data = Data(utf8)
        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}

// MARK: - 导入CommonCrypto
import CommonCrypto
