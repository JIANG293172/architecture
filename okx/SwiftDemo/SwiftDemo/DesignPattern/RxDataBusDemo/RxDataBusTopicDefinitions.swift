import Foundation
import RxDataBus

/// 演示 RxDataBus 如何定义强类型的 Topic
struct RxDataBusTopics {
    
    /// 用户登录状态 Topic (同步数据)
    struct UserLogin: RxDataBusTopic {
        typealias DataType = Bool
        let identifier = "rx.demo.userLogin"
    }
    
    /// 实时股市价格 Topic (瞬时流)
    struct StockPrice: RxDataBusTopic {
        typealias DataType = Double
        let identifier = "rx.demo.stockPrice"
    }
    
    /// 系统广播通知 Topic (瞬时事件)
    struct Broadcast: RxDataBusTopic {
        typealias DataType = String
        let identifier = "rx.demo.broadcast"
    }
    
    static let userLogin = UserLogin()
    static let stockPrice = StockPrice()
    static let broadcast = Broadcast()
}
