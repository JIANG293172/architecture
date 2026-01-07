import UIKit
import Combine

class ViewController: UIViewController {
    
}
    

    // 自定义一个简单的 Subscriber
    class SimpleSubscriber: Subscriber {
        typealias Input = String
        typealias Failure = Never
        
        // 当订阅建立时调用
        func receive(subscription: Subscription) {
            print("🔗 订阅建立了，开始请求数据")
            subscription.request(.unlimited) // 请求无限量的数据
        }
        
        // 当收到数据时调用
        func receive(_ input: String) -> Subscribers.Demand {
            print("📨 收到数据: \(input)")
            return .none // 不改变数据需求
        }
        
        // 当数据流完成时调用
        func receive(completion: Subscribers.Completion<Never>) {
            print("🏁 数据流完成")
        }
    }

    // 使用自定义 Subscriber
    func useCustomSubscriber() {
        let publisher = ["苹果", "香蕉", "橙子"].publisher
        let subscriber = SimpleSubscriber()
        
        publisher.subscribe(subscriber)
        
        // 输出：
        // 🔗 订阅建立了，开始请求数据
        // 📨 收到数据: 苹果
        // 📨 收到数据: 香蕉
        // 📨 收到数据: 橙子
        // 🏁 数据流完成
    }
