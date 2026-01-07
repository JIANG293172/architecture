//
//  DealerListViewModel.swift
//  dongchedi_combine
//
//  Created by CQCA202121101_2 on 2025/12/17.
//

import Foundation
import Combine

class DealerListViewModel: ObservableObject {
    // MARK: - 核心：用 CurrentValueSubject 替代 @Published（所有状态都手动控制事件）
    // 经销商列表（初始值为空数组）
    let dealerListSubject = CurrentValueSubject<[DealerModel], Never>([])
    // 加载状态（初始值为false）
    let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    // 错误信息（初始值为nil）
    let errorMessageSubject = CurrentValueSubject<String?, Never>(nil)
    // 询价结果（初始值为nil）
    let inquiryResultSubject = CurrentValueSubject<String?, Never>(nil)
    
    // MARK: - 暴露只读属性供 View 访问（避免 View 直接修改 Subject）
    var dealerList: [DealerModel] { dealerListSubject.value }
    var isLoading: Bool { isLoadingSubject.value }
    var errorMessage: String? { errorMessageSubject.value }
//    var inquiryResult: String? { inquiryResultSubject.value }
    
    // MARK: - 接收 View 传递的事件
    let loadDealerListSubject = PassthroughSubject<Void, Never>()
    let submitInquirySubject = PassthroughSubject<(dealerId: String, userName: String, phone: String, vehicleType: String), Never>()
    let callDealerSubject = PassthroughSubject<String, Never>()
    
    // 取消订阅容器
    private var cancellables = Set<AnyCancellable>()
    private let apiManager = DealerAPIManager.shared
    
    init() {
        bindAllEvents()
    }
}

// MARK: - 所有事件绑定逻辑
extension DealerListViewModel {
    private func bindAllEvents() {
        bindLoadDealerListEvent()
        bindSubmitInquiryEvent()
        bindCallDealerEvent()
    }
    
    // 绑定「加载经销商列表」事件
    private func bindLoadDealerListEvent() {
        loadDealerListSubject
            .handleEvents(receiveOutput: { [weak self] _ in
                // 开始加载：更新状态（手动 send 触发事件）
                self?.isLoadingSubject.send(true)
                self?.errorMessageSubject.send(nil)
            })
            .flatMap { [unowned self] _ -> AnyPublisher<[DealerModel], Error> in
                self.apiManager.fetchDealerList()
            }
            .sink(receiveCompletion: { [weak self] completion in
                // 结束加载
                self?.isLoadingSubject.send(false)
                
                // 处理失败
                if case .failure(let error) = completion {
                    self?.errorMessageSubject.send(error.localizedDescription)
                }
            }, receiveValue: { [weak self] dealers in
                // 数据赋值完成后，手动 send 事件（关键：确保数据就绪后再通知 View）
                self?.dealerListSubject.send(dealers)
                print("ViewModel 赋值经销商列表：\(dealers.count) 条数据")
            })
            .store(in: &cancellables)
    }
    
    // 绑定「提交询价」事件
    private func bindSubmitInquiryEvent() {
        submitInquirySubject
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.isLoadingSubject.send(true)
                self?.errorMessageSubject.send(nil)
                self?.inquiryResultSubject.send(nil)
            })
            .flatMap { [unowned self] (dealerId, userName, phone, vehicleType) -> AnyPublisher<InquiryResponseModel, Error> in
                let request = InquiryRequestModel(
                    dealerId: dealerId,
                    userName: userName,
                    phone: phone,
                    vehicleType: vehicleType
                )
                return self.apiManager.submitInquiry(request: request)
            }
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoadingSubject.send(false)
                
                if case .failure(let error) = completion {
                    self?.errorMessageSubject.send(error.localizedDescription)
                }
            }, receiveValue: { [weak self] response in
                self?.inquiryResultSubject.send(response.message)
            })
            .store(in: &cancellables)
    }
    
    // 绑定「拨打经销商电话」事件
    private func bindCallDealerEvent() {
        callDealerSubject
            .sink(receiveValue: { phone in
                print("正在拨打经销商电话：\(phone)")
                // 真实场景：调用系统拨号
                // if let url = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url) {
                //     UIApplication.shared.open(url)
                // }
            })
            .store(in: &cancellables)
    }
}
