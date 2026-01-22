//
//  NetworkService.swift
//  RxSwift02
//
//  Created by CQCA202121101_2 on 2025/11/6.
//

import Foundation
import RxSwift

protocol NetworkServiceType {
    func fetchUserInfo() -> Observable<User>
    func fetchProductionList() -> Observable<[Product]>
    func toggleFavorite(productId: Int) -> Observable<Bool>
}

class NetworkService: NetworkServiceType {

    
    static let shared = NetworkService()
    
    func fetchUserInfo() -> Observable<User> {
        let user = User(id: 123, name: "RxSwift用户", avatar: "https://picsum.photos/100/100", level: 3, points: 1500)
        
        return Observable.just(user)
            .delay(.seconds(1), scheduler: MainScheduler.instance)
        
    }
    
    
    func fetchProductionList() -> RxSwift.Observable<[Product]> {
        let products = [
            Product(id: 1, name: "iPhone14 pro", price: 7999.0, originalPrice: 8999.0, imageUrl: "https://picsum.photos/200/200?random=1", description: "最新款iPhone，搭载A16芯片", stock: 50, isFavorite: false),
            Product(id: 2, name: "MacBook Pro", price: 12999.0, originalPrice: nil, imageUrl: "https://picsum.photos/200/200?random=2", description: "16寸MacBook Pro，M2芯片", stock: 30, isFavorite: true),
            Product(id: 3, name: "AirPods Pro", price: 1899.0, originalPrice: 1999.0, imageUrl: "https://picsum.photos/200/200?random=3", description: "主动降噪无线耳", stock: 100, isFavorite: false),
        ]
        
        return Observable.just(products)
    }
    
    func toggleFavorite(productId: Int) -> RxSwift.Observable<Bool> {
        return Observable.just(true).delay(.milliseconds(500), scheduler: MainScheduler.instance)
    }
    
    
}
