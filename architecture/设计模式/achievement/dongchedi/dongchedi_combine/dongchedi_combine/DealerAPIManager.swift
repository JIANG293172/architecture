//
//  DealerAPIManager.swift
//  dongchedi_combine
//
//  Created by CQCA202121101_2 on 2025/12/17.
//

import Foundation
import Combine

class DealerAPIManager {
    static let shared = DealerAPIManager()
    private init() {} // 单例模式
    
    // 模拟获取经销商列表（2秒延迟）
    func fetchDealerList() -> AnyPublisher<[DealerModel], Error> {
        return Future<[DealerModel], Error> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                promise(.success(DealerModel.mockData))
                // 测试失败场景：promise(.failure(NSError(domain: "APIError", code: -1, userInfo: [NSLocalizedDescriptionKey: "网络请求失败"])))
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
        
        Future<Bool, Error> { promise in
            
        }
    }
    
    // 模拟提交询价（1.5秒延迟）
    func submitInquiry(request: InquiryRequestModel) -> AnyPublisher<InquiryResponseModel, Error> {
        return Future<InquiryResponseModel, Error> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
                guard request.phone.count == 11 else {
                    promise(.failure(NSError(domain: "InquiryError", code: 1001, userInfo: [NSLocalizedDescriptionKey: "手机号格式错误"])))
                    return
                }
                
                let response = InquiryResponseModel(
                    success: true,
                    message: "询价提交成功，经销商将在1个工作日内联系您",
                    inquiryId: "INQ\(Date().timeIntervalSince1970)"
                )
                promise(.success(response))
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
