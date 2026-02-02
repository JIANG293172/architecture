import Foundation

/// 下载任务状态
public enum DownloadStatus: Int, Codable {
    case waiting    // 等待中
    case downloading // 下载中
    case paused     // 已暂停
    case finished    // 已完成
    case failed      // 失败
}

/// 下载进度信息
public struct DownloadProgress {
    public let progress: Float      // 0.0 - 1.0
    public let totalSize: Int64     // 总大小
    public let currentSize: Int64   // 已下载大小
    public let speed: String        // 下载速度 (如: 1.2MB/s)
}

/// 下载错误类型
public enum DownloadError: Error {
    case invalidURL
    case fileError
    case networkError(Error)
    case serverError(Int) // HTTP 状态码
}
