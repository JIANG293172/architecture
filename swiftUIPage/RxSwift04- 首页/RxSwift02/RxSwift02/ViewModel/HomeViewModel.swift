//
//  HomeViewModel.swift
//  RxSwift02
//
//  Created by CQCA202121101_2 on 2025/11/6.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class HomeViewModel {
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let refresh: Observable<Void>
        let productSeleted: Observable<IndexPath>
        let favoriteTapped: Observable<Int>
        let profileTapped: Observable<Void>
    }
    
    struct Output {
        let user: Driver<User?>
        let products: Driver<[Product]>
        let isLoading: Driver<Bool>
        let error: Driver<String>
        let selectedProduct: Driver<Product>
        let navigateToProfile: Driver<Void>
    }
    
    private let networkService =  NetworkService.shared
    private let disposeBag = DisposeBag()
    
    init() {
    }
    
    func transForm(input: Input) -> Output {
        
        let loadingTracker = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        let loadTrigger = Observable.merge(
            input.viewDidLoad,
            input.refresh
        )
        
        let user = loadTrigger
            .flatMapLatest { [weak self] _ -> Observable<User?> in
                guard let self = self else { return .just(nil) }
                return self.networkService.fetchUserInfo()
                    .trackActivity(loadingTracker)
                    .trackError(errorTracker)
                    .map { $0 as User? } // 正常情况将User转换为User?
                    .catchError { _ in .just(nil) } // 错误时返回nil
            }
            .asDriver(onErrorJustReturn: nil)
        
        let products = loadTrigger
            .flatMapLatest { [weak self] _ ->Observable<[Product]> in
                guard let self = self else { return .empty() }
                return self.networkService.fetchProductionList()
                    .trackActivity(loadingTracker)
                    .trackError(errorTracker)
            }.asDriver(onErrorJustReturn: [])
        
        let selectedProduct = input.productSeleted
            .withLatestFrom(products) { IndexPath, products in
                products[IndexPath.row]
            }
            .asDriver(onErrorDriveWith: .empty())
        
        input.favoriteTapped
            .flatMapLatest { [weak self] productID -> Observable<Bool> in
                guard let self = self else  { return .empty()}
                return self.networkService.toggleFavorite(productId: productID)
                    .trackError(errorTracker)
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        return Output(user: user,
                      products: products,
                      isLoading: loadingTracker.asDriver(),
                      error: errorTracker.asDriver().map({
            $0.localizedDescription
        })
                      , selectedProduct: selectedProduct,
                      navigateToProfile: input.profileTapped.asDriver(onErrorDriveWith: .empty()))
        
    }
    
    func  gotoDetail() {
        /// 跳转
    }
    
}


extension ObservableConvertibleType {
    func trackActivity(_ activityIndicator: ActivityIndicator) -> Observable<Element> {
        return activityIndicator.trackActivityOfObservable(self)
    }
    
    func  trackError(_ errorTracker: ErrorTracker) -> Observable<Element> {
        return errorTracker.trackError(from: self)
    }
}

