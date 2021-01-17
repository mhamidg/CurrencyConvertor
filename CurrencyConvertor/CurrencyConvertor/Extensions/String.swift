//
//  String.swift
//  CurrencyConvertor
//
//  Created by Hamid Farooq on 16/01/2021.
//

import Foundation

extension String {
    
    public var currencyCode: String {
        guard count == 6 else { return self }
        return String(dropFirst(3))
    }
}
