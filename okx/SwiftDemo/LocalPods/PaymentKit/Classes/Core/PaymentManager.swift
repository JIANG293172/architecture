import Foundation
import UIKit


//- PaymentManager (门面模式) : 作为支付组件的唯一入口。业务方不需要关心具体支付渠道的初始化和处理逻辑，只需调用 startPay 即可。
//- PaymentChannelProtocol (策略模式接口) : 定义了所有支付渠道必须遵循的行为（如 isAvailable , pay , handleOpenURL ）。这使得添加新的支付方式（如银联、Stripe）只需新增一个类实现该协议，无需修改核心管理器代码（符合 开闭原则 ）。
//- 解耦设计 :
//  - 业务解耦 : 业务方只持有 PaymentManager 和 PaymentOrder 模型。
//  - SDK 隔离 : 具体的第三方 SDK 逻辑被封装在 AliPayChannel 等具体实现类内部，如果未来要更换 SDK 版本或逻辑，只需修改对应的 Channel 类。
//- 统一结果处理 : 定义了 PaymentResult 枚举，将不同 SDK 返回的各种错误码统一映射为业务友好的错误类型。
//### 3. 封装话术建议 (如何展示 8 年资深水平)
//当封装官问“你如何设计一个支付组件”时，你可以按以下节奏回答：
//
//1. 架构分层 : "我会将支付组件设计为一个独立的私有库。

//最上层是一个门面管理器。"
//底层是统一的支付模型和协议层，
//中间是各个支付渠道的策略实现，

//2. 解决痛点 : "核心要解决两个痛点： 一是业务方接入成本高 （需要处理各种 SDK 的初始化和回调）， 二是代码维护困难 （多个支付方式混在一起）。"
//3. 安全性与健壮性 : "我会强调订单信息的不可变性（Immutable Models），并提供统一的异常处理机制。同时利用协议抽象，支持 App 跳转回调的链式处理，避免在 AppDelegate 中写大量的 if-else 。"
//4. 动态性 : "该架构支持动态注册渠道。比如我们可以根据后端配置，在运行时决定显示哪些支付方式，或者针对不同地区注册不同的本地支付渠道。"
//### 4. 实现代码参考
//- 核心管理器 : PaymentManager.swift
//- 统一协议 : PaymentProtocol.swift
//- 支付宝实现示例 : AliPayChannel.swift
//- 演示页面 : PayDemoViewController.swift

//门面模式 (Facade)
//简化接口 。把内部复杂的子系统（多个支付渠道）包装起来，给外部提供一个简单、统一的 API。
//关注 接口的收敛 。外部只看 PaymentManager ，不看内部的 AliPay 、 WeChatPay 。
//一对多 ：一个门面对应多个子系统组件。

/// 支付管理类：对外提供的唯一入口（Facade 模式）
public final class PaymentManager {
    
    public static let shared = PaymentManager()
    
    /// 已注册的支付渠道
    private var channels: [PaymentMethod: PaymentChannelProtocol] = [:]
    
    private init() {}
    
    /// 注册支付渠道（通常在 AppDelegate 启动时注册）
    public func register(channel: PaymentChannelProtocol) {
        channels[channel.method] = channel
    }
    
    /// 发起支付
    /// - Parameters:
    ///   - method: 支付方式
    ///   - order: 订单信息
    ///   - completion: 结果回调
    public func startPay(method: PaymentMethod, order: PaymentOrder, completion: @escaping (PaymentResult) -> Void) {
        guard let channel = channels[method] else {
            completion(.failure(error: .channelNotSupported))
            return
        }
        
        guard channel.isAvailable() else {
            completion(.failure(error: .channelNotInstalled))
            return
        }
        
        print("💳 [PaymentManager] 路由到渠道: \(method.rawValue), 订单ID: \(order.orderId)")
        channel.pay(order: order, completion: completion)
    }
    
    /// 处理 App 回调
    public func handleOpenURL(_ url: URL) -> Bool {
        for channel in channels.values {
            if channel.handleOpenURL(url) {
                return true
            }
        }
        return false
    }
}
