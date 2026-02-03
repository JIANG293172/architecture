import Foundation

/// 下载任务类：封装单个下载任务的行为
public final class DownloadTask: NSObject {
    
    public let url: URL
    public var status: DownloadStatus = .waiting
    
    // 回调闭包
    public var progressHandler: ((DownloadProgress) -> Void)?
    public var completionHandler: ((Result<URL, DownloadError>) -> Void)?
    
    private var sessionTask: URLSessionDownloadTask?
    private let persistence = DownloadPersistence()
    
    init(url: URL) {
        self.url = url
        super.init()
    }
    
    /// 开始/恢复下载
    /// 封装回答点：
    /// 1. 首次下载：使用 session.downloadTask(with: url)
    /// 2. 断点续传：从本地读取 resumeData，使用 session.downloadTask(withResumeData: data)
    func resume(in session: URLSession) {
        guard status != .downloading else { return }
        
        if let resumeData = persistence.getResumeData(for: url) {
            print("📦 [DownloadTask] 发现断点数据，尝试续传: \(url.lastPathComponent)")
            sessionTask = session.downloadTask(withResumeData: resumeData)
        } else {
            print("🚀 [DownloadTask] 开始全新下载: \(url.lastPathComponent)")
            sessionTask = session.downloadTask(with: url)
        }
        
        sessionTask?.resume()
        status = .downloading
    }
    
    /// 暂停下载
    /// 封装回答点：
    /// 调用 cancel(byProducingResumeData:) 是断点续传的关键。
    /// 系统会回调并提供 resumeData，我们需要将其持久化。
    func pause() {
        guard status == .downloading else { return }
        
        sessionTask?.cancel { [weak self] data in
            guard let self = self, let data = data else { return }
            self.persistence.saveResumeData(data, for: self.url)
            DispatchQueue.main.async {
                self.status = .paused
                print("⏸ [DownloadTask] 任务已暂停并保存断点: \(self.url.lastPathComponent)")
            }
        }
    }
    
    // 供 Manager 调用的内部更新方法
    func updateProgress(current: Int64, total: Int64) {
        let p = Float(current) / Float(total)
        let progress = DownloadProgress(progress: p, totalSize: total, currentSize: current, speed: "--")
        DispatchQueue.main.async {
            self.progressHandler?(progress)
        }
    }
}
