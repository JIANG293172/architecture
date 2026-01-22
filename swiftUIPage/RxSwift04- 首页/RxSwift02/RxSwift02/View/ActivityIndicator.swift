//
//  ActivityIndicator.swift
//  RxSwift02
//
//  Created by CQCA202121101_2 on 2025/11/10.
//

import RxCocoa
import RxSwift

class ActivityIndicator: SharedSequenceConvertibleType {
    
    typealias Element = Bool
    typealias SharingStrategy = DriverSharingStrategy
    
    private let _lock = NSRecursiveLock()
    private let _relay = BehaviorRelay(value: false)
    private let _loading: SharedSequence<SharingStrategy, Bool>
    
    init() {
        _loading = _relay.asDriver().distinctUntilChanged()
    }
    
    func trackActivityOfObservable<O: ObservableConvertibleType>(_ source: O) -> Observable<O.Element> {
        
        return source.asObservable()
            .do( onNext:{ _ in
                self.sendStopLoading()
            }, onError: { _ in
                self.sendStopLoading()
            }, onCompleted: {
                self.sendStopLoading()
            }, onSubscribe: subscribed)
    }
        
    private func subscribed() {
        _lock.lock()
        _relay.accept(true)
        _lock.unlock()
    }
    
    
    private func sendStopoLoading() {
        _lock.lock()
        _relay.accept(false)
        _lock.unlock()
    }
    
    private func sendStopLoading() {
        _lock.lock()
        _relay.accept(false)
        _lock.unlock()
    }
    
    public func asSharedSequence() -> SharedSequence<SharingStrategy, Element> {
        return _loading
    }
    
}
