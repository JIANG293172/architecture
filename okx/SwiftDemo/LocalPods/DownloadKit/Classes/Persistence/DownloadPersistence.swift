import Foundation

/// 断点数据管理：封装重点 - 如何确保持久化和一致性
public final class DownloadPersistence {
    
    private let queue = DispatchQueue(label: "com.downloadkit.persistence")
    private let fileManager = FileManager.default
    
    /// 获取 Resume Data 存储路径
    /// 原理：URLSession 提供 resumeData (XML 格式)，包含下载 URL、已接收字节、ETag 等。
    private func resumeDataPath(for url: URL) -> URL {
        let name = url.absoluteString.data(using: .utf8)?.base64EncodedString() ?? "\(url.hashValue)"
        let path = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        return path.appendingPathComponent("DownloadResume_\(name)")
    }
    
    /// 保存断点数据
    public func saveResumeData(_ data: Data, for url: URL) {
        queue.async {
            try? data.write(to: self.resumeDataPath(for: url))
        }
    }
    
    /// 读取断点数据
    public func getResumeData(for url: URL) -> Data? {
        return try? Data(contentsOf: resumeDataPath(for: url))
    }
    
    /// 删除断点数据
    public func removeResumeData(for url: URL) {
        queue.async {
            try? self.fileManager.removeItem(at: self.resumeDataPath(for: url))
        }
    }
    
    /// 获取文件最终存放路径
    public func finalPath(for url: URL) -> URL {
        let path = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return path.appendingPathComponent(url.lastPathComponent)
    }
}
