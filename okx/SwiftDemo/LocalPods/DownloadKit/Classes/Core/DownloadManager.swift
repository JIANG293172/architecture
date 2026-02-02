import Foundation

/// 下载管理器：Facade 模式，管理所有下载任务
///
///

//- URLSessionDownloadTask 的断点原理 :
//  
//  - 暂停 : 调用 cancel(byProducingResumeData:) 。系统会生成一个 resumeData (XML 格式)，包含已下载字节、ETag、服务器 URL 等。
//  - 恢复 : 使用 session.downloadTask(withResumeData:) 。
//  - 代码参考 : DownloadTask.swift
//- 异常中断处理 (Network Kill) :
//  
//  - 当 App 崩溃或网络突然断开时，系统会回调 urlSession(_:task:didCompleteWithError:) 。
//  - 核心细节 : 必须从 error.userInfo[NSURLSessionDownloadTaskResumeData] 中提取 resumeData 并手动保存，否则之前的下载进度会丢失。
//  - 代码参考 : DownloadManager.swift 的 didCompleteWithError 部分。
//- 后台下载 (Background Session) :
//  
//  - 使用了 URLSessionConfiguration.background 。这确保了即使用户手动杀死 App 或系统挂起 App，下载任务依然由系统的守护进程继续执行。
//
//
//
//1. 架构思想 : "我采用 Facade（外观模式） 统一管理下载任务，
//并引入了专门的 Persistence（持久化层） 来处理断点数据的读写。这种职责分离确保了任务管理与状态存储的解耦。"

//2. 文件管理安全 : "在处理 didFinishDownloadingTo 时，我考虑到系统提供的路径是临时的。我的组件会在回调的第一时间使用 FileManager 将其移动到沙盒的 Documents 目录，防止数据被系统清理。"
//3. 并发与线程安全 : "为了支持多任务并行，我使用了 NSLock 保护任务字典，并确保所有的进度和状态回调都切换到主线程，避免 UI 竞争问题。"

//### 4. 如何体验演示？
//1. 点击主页面的 “Business Architecture (Payment Kit)” （这里我把入口放在了业务架构目录下）。
//2. 选择 “断点续传架构” 。
//3. 点击 “开始下载” ，你会看到进度条滚动。
//4. 点击 “暂停” ，再次点击 “继续” ，你会发现进度条从之前的位置继续，而不是重新开始。



public final class DownloadManager: NSObject {
    
    public static let shared = DownloadManager()
    
    private var session: URLSession!
    private var tasks: [URL: DownloadTask] = [:]
    private let lock = NSLock()
    private let persistence = DownloadPersistence()
    
    private override init() {
        super.init()
        // 点：Background Session 支持应用退出后继续下载
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
