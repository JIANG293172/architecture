import Foundation

/// 下载管理器：Facade 模式，管理所有下载任务
public final class DownloadManager: NSObject {
    
    public static let shared = DownloadManager()
    
    private var session: URLSession!
    private var tasks: [URL: DownloadTask] = [:]
    private let lock = NSLock()
    private let persistence = DownloadPersistence()
    
    private override init() {
        super.init()
        // 面试回答点：Background Session 支持应用退出后继续下载
        let config = URLSessionConfiguration.background(withIdentifier: "com.downloadkit.background")
        self.session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }
    
    /// 创建并开始任务
    public func download(_ urlString: String) -> DownloadTask? {
        guard let url = URL(string: urlString) else { return nil }
        
        lock.lock()
        defer { lock.unlock() }
        
        if let existing = tasks[url] {
            existing.resume(in: session)
            return existing
        }
        
        let task = DownloadTask(url: url)
        tasks[url] = task
        task.resume(in: session)
        return task
    }
    
    /// 暂停任务
    public func pause(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        tasks[url]?.pause()
    }
}

// MARK: - URLSessionDelegate
extension DownloadManager: URLSessionDownloadDelegate {
    
    // 下载进度回调
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard let url = downloadTask.originalRequest?.url ?? downloadTask.currentRequest?.url else { return }
        tasks[url]?.updateProgress(current: totalBytesWritten, total: totalBytesExpectedToWrite)
    }
    
    // 下载完成回调
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let url = downloadTask.originalRequest?.url ?? downloadTask.currentRequest?.url else { return }
        
        let destination = persistence.finalPath(for: url)
        
        do {
            // 面试回答点：didFinishDownloadingTo 提供的是临时路径，必须立即移动到持久化目录
            if FileManager.default.fileExists(atPath: destination.path) {
                try FileManager.default.removeItem(at: destination)
            }
            try FileManager.default.moveItem(at: location, to: destination)
            
            // 清理断点数据
            persistence.removeResumeData(for: url)
            
            DispatchQueue.main.async {
                self.tasks[url]?.status = .finished
                self.tasks[url]?.completionHandler?(.success(destination))
                print("✅ [DownloadManager] 下载完成: \(destination.path)")
            }
        } catch {
            DispatchQueue.main.async {
                self.tasks[url]?.status = .failed
                self.tasks[url]?.completionHandler?(.failure(.fileError))
            }
        }
    }
    
    // 错误处理（包括断点保存）
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let url = task.originalRequest?.url ?? task.currentRequest?.url else { return }
        
        if let error = error as NSError? {
            // 面试重点：网络异常中断（如断网）时，从 error.userInfo 中提取 resumeData
            if let resumeData = error.userInfo[NSURLSessionDownloadTaskResumeData] as? Data {
                persistence.saveResumeData(resumeData, for: url)
                print("⚠️ [DownloadManager] 网络中断，已自动保存断点: \(url.lastPathComponent)")
            }
            
            DispatchQueue.main.async {
                self.tasks[url]?.status = .failed
                self.tasks[url]?.completionHandler?(.failure(.networkError(error)))
            }
        }
    }
}
