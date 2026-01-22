//
//  ErrorTracker.swift
//  RxSwift02
//
//  Created by CQCA202121101_2 on 2025/11/10.
//

import Foundation
import RxCocoa
import RxSwift

class ErrorTracker: SharedSequenceConvertibleType {
    typealias SharingStrategy = DriverSharingStrategy
    private let _subject = PublishSubject<Error>()
    
    func trackError<O: ObservableConvertibleType>(from source: O) -> Observable<O.Element> {
        return source.asObservable().do(onError: onError)
    }
    
    func asSharedSequence() -> SharedSequence<DriverSharingStrategy, Error> {
        return _subject.asDriver(onErrorDriveWith: .empty())
    }
    
    func asObservable() -> Observable<Error> {
        return _subject.asObservable()
    }
    
    private func onError(_ error: Error) {
        _subject.onNext(error)
    }
    
    deinit {
        _subject.onCompleted()
    }
    
}
