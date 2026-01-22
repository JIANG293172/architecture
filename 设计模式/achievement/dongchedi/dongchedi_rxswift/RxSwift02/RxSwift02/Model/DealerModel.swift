//
//  DealerModel.swift
//  RxSwift02
//
//  Created by CQCA202121101_2 on 2025/12/18.
//

import Foundation

// Dealer data model (matches business attributes)
struct DealerModel: Codable {
    let id: String          // Unique dealer ID
    let name: String        // Dealer name
    let address: String     // Dealer address
    let phone: String       // Contact phone
    let minPrice: Double    // Minimum vehicle price
    let isAuthorized: Bool  // Is authorized dealer
}
