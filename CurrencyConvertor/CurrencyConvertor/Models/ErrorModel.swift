//
//  ErrorModel.swift
//  CurrencyConvertor
//
//  Created by Hamid Farooq on 14/01/2021.
//

import Foundation

struct ErrorModel: Decodable, Error {
    
    let success: Bool
    let error: ErrorDetailModel
}
