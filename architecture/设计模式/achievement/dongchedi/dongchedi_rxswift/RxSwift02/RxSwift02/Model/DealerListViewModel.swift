//
//  DealerListViewModel.swift
//  RxSwift02
//
//  Created by CQCA202121101_2 on 2025/12/18.
//

import Foundation
import RxSwift
import RxCocoa

class DealerListViewModel {
    // MARK: - Dependencies
    private let apiManager: DealerAPIManager
    private let disposeBag = DisposeBag() // Manage subscription lifecycle
    
    // MARK: - State Management (Persistent State: BehaviorSubject)
    /// Dealer list (initial value: empty array)
    let dealerListSubject = BehaviorSubject<[DealerModel]>(value: [])
    /// Loading status (initial value: false)
    let isLoadingSubject = BehaviorSubject<Bool>(value: false)
    /// Error message (initial value: nil)
    let errorMessageSubject = BehaviorSubject<String?>(value: nil)
    /// Inquiry submission result (initial value: nil)
    let inquiryResultSubject = BehaviorSubject<String?>(value: nil)
    
    // MARK: - Event Triggers (One-time Events: PublishSubject)
    /// Trigger dealer list loading (no data carried)
    let loadDealerListTrigger = PublishSubject<Void>()
    /// Trigger inquiry submission (carries user input params)
    let submitInquiryTrigger = PublishSubject<(dealerId: String, userName: String, phone: String, vehicleType: String)>()
    /// Trigger dealer call (carries phone number)
    let callDealerTrigger = PublishSubject<String>()
    
    // MARK: - Initializer
    init(apiManager: DealerAPIManager = .shared) {
        self.apiManager = apiManager
        bindLogic() // Bind trigger events to business logic
    }
    
    // MARK: - Logic Binding
    private func bindLogic() {
        // 1. Bind load trigger to dealer list fetch
        bindLoadDealerList()
        
        // 2. Bind inquiry trigger to submission
        bindSubmitInquiry()
        
        // 3. Bind call trigger to phone call logic
        bindCallDealer()
    }
    
    /// Bind load trigger to API request + state update
    private func bindLoadDealerList() {
        loadDealerListTrigger
            .do(onNext: { [weak self] _ in
                // Side effect: Start loading, clear previous error
                self?.isLoadingSubject.onNext(true)
                self?.errorMessageSubject.onNext(nil)
            })
            .flatMapLatest { [weak self] _ -> Observable<[DealerModel]> in
                // Convert trigger to API request (flatMapLatest cancels previous uncompleted request)
                guard let self = self else { return Observable.empty() }
                return self.apiManager.fetchDealerList()
                    .catch { error -> Observable<[DealerModel]> in
                        // Handle API error
                        self.errorMessageSubject.onNext(error.localizedDescription)
                        return Observable.empty()
                    }
            }
            .subscribe(onNext: { [weak self] dealers in
                // Update dealer list on success
                self?.dealerListSubject.onNext(dealers)
            }, onCompleted: { [weak self] in
                // Stop loading when request completes
                self?.isLoadingSubject.onNext(false)
            })
            .disposed(by: disposeBag)
    }
    
    /// Bind inquiry trigger to submission API
    private func bindSubmitInquiry() {
        submitInquiryTrigger
            .do(onNext: { [weak self] _ in
                self?.isLoadingSubject.onNext(true)
                self?.inquiryResultSubject.onNext(nil)
                self?.errorMessageSubject.onNext(nil)
            })
            .flatMapLatest { [weak self] params -> Observable<String> in
                guard let self = self else { return Observable.empty() }
                return self.apiManager.submitInquiry(params: params)
                    .catch { error -> Observable<String> in
                        self.errorMessageSubject.onNext(error.localizedDescription)
                        return Observable.empty()
                    }
            }
            .subscribe(onNext: { [weak self] result in
                self?.inquiryResultSubject.onNext(result)
            }, onCompleted: { [weak self] in
                self?.isLoadingSubject.onNext(false)
            })
            .disposed(by: disposeBag)
    }
    
    /// Bind call trigger to phone call (simulate system call)
    private func bindCallDealer() {
        callDealerTrigger
            .subscribe(onNext: { phoneNumber in
                // Simulate opening system call interface
                if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Helper: Get current state value (safe unwrap)
extension BehaviorSubject {
    func currentValue() -> Element? {
        do {
            return try value()
        } catch {
            return nil
        }
    }
}
