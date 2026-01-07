//
//  DealerModel.swift
//  dongchedi_combine
//
//  Created by CQCA202121101_2 on 2025/12/17.
//

import Foundation

struct DealerModel: Identifiable, Codable {
    let id: String
    let name: String          // 经销商名称
    let address: String       // 地址
    let phone: String         // 电话
    let mainVehicleType: String // 主营车型
    let minPrice: Double      // 最低报价（万元）
    let isAuthorized: Bool    // 是否官方授权
}

extension DealerModel {
    static var mockData: [DealerModel] {
        [
            DealerModel(
                id: "1001",
                name: "北京懂车帝官方旗舰店",
                address: "北京市朝阳区建国路88号",
                phone: "400-888-8888",
                mainVehicleType: "新能源汽车",
                minPrice: 15.99,
                isAuthorized: true
            ),
            DealerModel(
                id: "1002",
                name: "上海汽车贸易有限公司",
                address: "上海市浦东新区张江高科技园区",
                phone: "400-999-9999",
                mainVehicleType: "燃油车+混动",
                minPrice: 12.58,
                isAuthorized: false
            ),
            DealerModel(
                id: "1003",
                name: "广州新能源体验中心",
                address: "广州市天河区珠江新城",
                phone: "400-777-7777",
                mainVehicleType: "纯电动",
                minPrice: 18.88,
                isAuthorized: true
            )
        ]
    }
}
