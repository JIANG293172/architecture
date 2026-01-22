//
//  CarControlService.swift.swift
//  RxSwift02
//
//  Created by CQCA202121101_2 on 2025/11/17.
//

// Services/CarControlService.swift
import RxSwift
import Foundation

protocol CarControlServiceType {
    func fetchCarStatus() -> Observable<CarStatus>
    func fetchControlFunctions() -> Observable<[ControlFunction]>
    func fetchBanners() -> Observable<[Banner]>
    func toggleAC() -> Observable<Bool>
    func toggleQuickCool() -> Observable<Bool>
    func lockCar() -> Observable<Bool>
    func unlockCar() -> Observable<Bool>
}

class CarControlService: CarControlServiceType {
    
    static let shared = CarControlService()
    
    func fetchCarStatus() -> Observable<CarStatus> {
        let status = CarStatus(
            totalMileage: 25677,
            remainingRange: 586,
            currentRange: 265,
            batteryLevel: 85,
            lockStatus: true,
            windowStatus: false,
            tirePressure: [2.5, 2.5, 2.4, 2.5]
        )
        return Observable.just(status)
            .delay(.seconds(1), scheduler: MainScheduler.instance)
    }
    
    func fetchControlFunctions() -> Observable<[ControlFunction]> {
        let functions = [
            // 基础远控
            ControlFunction(id: "1", name: "车门解锁", icon: "lock.open", type: .digitalKey),
            ControlFunction(id: "2", name: "车窗控制", icon: "car.window.left", type: .digitalKey),
            ControlFunction(id: "3", name: "寻车", icon: "location.circle", type: .digitalKey),
            ControlFunction(id: "4", name: "空调预热", icon: "thermometer.sun", type: .airConditioner),
            
            // 空调控制
            ControlFunction(id: "5", name: "智能空调", icon: "air.conditioner.horizontal", type: .airConditioner),
            ControlFunction(id: "6", name: "速冷模式", icon: "snowflake", type: .quickCool),
            ControlFunction(id: "7", name: "速热模式", icon: "flame", type: .quickCool),
            
            // 车辆信息
            ControlFunction(id: "8", name: "车辆状态", icon: "car.fill", type: .safetyService),
            ControlFunction(id: "9", name: "电池信息", icon: "battery.100", type: .safetyService),
            
            // 辅助驾驶
            ControlFunction(id: "10", name: "直进直出", icon: "arrow.left.arrow.right", type: .assistedDriving),
            ControlFunction(id: "11", name: "遥控泊车", icon: "parkingsign", type: .assistedDriving),
            
            // 用车服务
            ControlFunction(id: "12", name: "OTA升级", icon: "arrow.triangle.2.circlepath", type: .vehicleService),
            ControlFunction(id: "13", name: "车辆分享", icon: "person.2", type: .carSharing),
            ControlFunction(id: "14", name: "行程记录", icon: "map", type: .vehicleService),
            ControlFunction(id: "15", name: "电子围栏", icon: "circle.dashed", type: .safetyService),
            ControlFunction(id: "16", name: "更多服务", icon: "ellipsis.circle", type: .moreService)
        ]
        
        return Observable.just(functions)
            .delay(.milliseconds(500), scheduler: MainScheduler.instance)
    }
    
    func fetchBanners() -> Observable<[Banner]> {
        let banners = [
            Banner(
                id: "1",
                imageUrl: "https://picsum.photos/400/200?random=1",
                title: "长安深蓝SL03 全新上市",
                linkUrl: "https://changan.com/sl03"
            ),
            Banner(
                id: "2",
                imageUrl: "https://picsum.photos/400/200?random=2",
                title: "冬季保养优惠活动",
                linkUrl: "https://changan.com/service"
            ),
            Banner(
                id: "3",
                imageUrl: "https://picsum.photos/400/200?random=3",
                title: "OTA新版本发布",
                linkUrl: "https://changan.com/ota"
            )
        ]
        
        return Observable.just(banners)
            .delay(.milliseconds(300), scheduler: MainScheduler.instance)
    }
    
    func toggleAC() -> Observable<Bool> {
        return Observable.just(true)
            .delay(.milliseconds(800), scheduler: MainScheduler.instance)
    }
    
    func toggleQuickCool() -> Observable<Bool> {
        return Observable.just(true)
            .delay(.milliseconds(600), scheduler: MainScheduler.instance)
    }
    
    func lockCar() -> Observable<Bool> {
        return Observable.just(true)
            .delay(.milliseconds(500), scheduler: MainScheduler.instance)
    }
    
    func unlockCar() -> Observable<Bool> {
        return Observable.just(true)
            .delay(.milliseconds(500), scheduler: MainScheduler.instance)
    }
}
