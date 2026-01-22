//
//  HomeViewModel.swift.swift
//  RxSwift02
//
//  Created by CQCA202121101_2 on 2025/11/17.
//

// ViewModels/HomeViewModel.swift
// ViewModels/HomeViewModel.swift
import RxSwift
import RxCocoa

class HomeViewModel {
    
    // MARK: - Input
    struct Input {
        let viewDidLoad: Observable<Void>
        let refresh: Observable<Void>
        let functionTapped: Observable<ControlFunction>
        let bannerTapped: Observable<Banner>
    }
    
    // MARK: - Output
    struct Output {
        let carStatus: Driver<CarStatus?>  // 可选类型
        let functions: Driver<[ControlFunction]>
        let banners: Driver<[Banner]>
        let isLoading: Driver<Bool>
        let error: Driver<String>
        let selectedFunction: Driver<ControlFunction>
        let selectedBanner: Driver<Banner>
    }
    
    private let carControlService: CarControlServiceType
    private let disposeBag = DisposeBag()
    
    init(carControlService: CarControlServiceType = CarControlService.shared) {
        self.carControlService = carControlService
    }
    
    func transform(input: Input) -> Output {
        let loadingTracker = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        let loadTrigger = Observable.merge(
            input.viewDidLoad,
            input.refresh
        )
        
        // 车辆状态 - 返回可选类型
        let carStatus = loadTrigger
            .flatMapLatest { [weak self] _ -> Observable<CarStatus> in
                guard let self = self else { return .empty() }
                return self.carControlService.fetchCarStatus()
                    .trackActivity(loadingTracker)
                    .trackError(errorTracker)
            }
            .map { $0 as CarStatus? } // 转换为可选类型
            .asDriver(onErrorJustReturn: nil)  // 现在可以返回 nil
            
        // 控制功能
        let functions = loadTrigger
            .flatMapLatest { [weak self] _ -> Observable<[ControlFunction]> in
                guard let self = self else { return .empty() }
                return self.carControlService.fetchControlFunctions()
                    .trackActivity(loadingTracker)
                    .trackError(errorTracker)
            }
            .asDriver(onErrorJustReturn: [])
        
        // 轮播图
        let banners = loadTrigger
            .flatMapLatest { [weak self] _ -> Observable<[Banner]> in
                guard let self = self else { return .empty() }
                return self.carControlService.fetchBanners()
                    .trackActivity(loadingTracker)
                    .trackError(errorTracker)
            }
            .asDriver(onErrorJustReturn: [])
        
        // 功能点击
        let selectedFunction = input.functionTapped
            .asDriver(onErrorDriveWith: .empty())
        
        // 轮播图点击
        let selectedBanner = input.bannerTapped
            .asDriver(onErrorDriveWith: .empty())
        
        return Output(
            carStatus: carStatus,
            functions: functions,
            banners: banners,
            isLoading: loadingTracker.asDriver(),
            error: errorTracker.asDriver().map { $0.localizedDescription },
            selectedFunction: selectedFunction,
            selectedBanner: selectedBanner
        )
    }
}
