//
//  InquiryModel.swift
//  dongchedi_combine
//
//  Created by CQCA202121101_2 on 2025/12/17.
//
import Foundation

// 询价请求参数模型
struct InquiryRequestModel: Codable {
    let dealerId: String      // 经销商ID
    let userName: String      // 用户名
    let phone: String         // 用户电话
    let vehicleType: String   // 意向车型
    let createTime: Date = Date()
}

// 询价响应模型
struct InquiryResponseModel: Codable {
    let success: Bool
    let message: String
    let inquiryId: String?    // 询价单号（成功时返回）
}
