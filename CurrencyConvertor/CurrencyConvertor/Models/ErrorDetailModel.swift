//
//  ErrorDetailModel.swift
//  CurrencyConvertor
//
//  Created by Hamid Farooq on 14/01/2021.
//

import Foundation

struct ErrorDetailModel: Decodable {
    
    let code: Int
    let info: String
}
