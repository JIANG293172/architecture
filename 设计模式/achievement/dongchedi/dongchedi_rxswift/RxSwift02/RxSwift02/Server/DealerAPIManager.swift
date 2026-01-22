//
//  DealerAPIManager.swift
//  RxSwift02
//
//  Created by CQCA202121101_2 on 2025/12/18.
//

import Foundation
import RxSwift

class DealerAPIManager {
    static let shared = DealerAPIManager()
    private init() {} // Singleton pattern
    
    /// Fetch dealer list (simulate API with 2s delay)
    /// - Returns: Observable of dealer list (emits data or error)
    func fetchDealerList() -> Observable<[DealerModel]> {
        return Observable.create { observer in
            // Simulate network request delay
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                // Mock success data (replace with real API request in production)
                let mockDealers = [
                    DealerModel(id: "1", name: "Changan Auto Beijing Dealer", address: "Haidian District, Beijing", phone: "1008611", minPrice: 129800, isAuthorized: true),
                    DealerModel(id: "2", name: "Changan Auto Shanghai Dealer", address: "Pudong New Area, Shanghai", phone: "1008612", minPrice: 132800, isAuthorized: true),
                    DealerModel(id: "3", name: "Changan Auto Guangzhou Dealer", address: "Tianhe District, Guangzhou", phone: "1008613", minPrice: 127800, isAuthorized: false)
                ]
                
                // Simulate random error (comment out to test success)
                // let randomError = NSError(domain: "DealerAPI", code: -1001, userInfo: [NSLocalizedDescriptionKey: "Network timeout"])
                // observer.onError(randomError)
                
                // Emit success data
                observer.onNext(mockDealers)
                observer.onCompleted() // Mark request completion
            }
            return Disposables.create() // Return disposable for cancellation
        }
    }
    
    /// Submit dealer inquiry (simulate API)
    /// - Parameter params: Inquiry parameters (dealerId, userName, phone, vehicleType)
    /// - Returns: Observable of submission result
    func submitInquiry(params: (dealerId: String, userName: String, phone: String, vehicleType: String)) -> Observable<String> {
        return Observable.create { observer in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
                // Simulate success response
                let result = "Inquiry submitted successfully! Dealer will contact you within 24 hours."
                observer.onNext(result)
                observer.onCompleted()
                
                // Simulate error (uncomment to test)
                // let error = NSError(domain: "InquiryAPI", code: -2001, userInfo: [NSLocalizedDescriptionKey: "Invalid phone number"])
                // observer.onError(error)
            }
            return Disposables.create()
        }
    }
}
