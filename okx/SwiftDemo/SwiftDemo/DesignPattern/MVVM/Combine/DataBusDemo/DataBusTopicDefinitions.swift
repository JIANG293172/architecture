import Foundation
import CombineDataBus

/// 演示如何定义强类型的 Topic
struct DataBusTopics {
    
    /// 用户登录状态 Topic
    struct LoginStatus: DataBusTopic {
        typealias DataType = Bool
        let identifier = "com.demo.loginStatus"
    }
    
    /// 全局主题颜色 Topic (同步数据)
    struct ThemeColor: DataBusTopic {
        typealias DataType = String // hex color
        let identifier = "com.demo.themeColor"
    }
    
    /// 全局系统通知 Topic (瞬时事件)
    struct SystemAlert: DataBusTopic {
        typealias DataType = String
        let identifier = "com.demo.systemAlert"
    }
    
    // 静态实例方便使用
    static let login = LoginStatus()
    static let theme = ThemeColor()
    static let alert = SystemAlert()
}
