//
//  ResponseModel.swift
//  CurrencyConvertor
//
//  Created by Hamid Farooq on 14/01/2021.
//

import Foundation

typealias CurrencyType = [String: Float]

struct ResponseModel: Decodable {
    
    let success: Bool
    let timestamp: TimeInterval
    let source: String
    let terms: String
    let privacy: String
    let quotes: CurrencyType
}
