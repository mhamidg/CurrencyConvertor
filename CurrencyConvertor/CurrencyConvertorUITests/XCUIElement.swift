//
//  XCUIElement.swift
//  CurrencyConvertorUITests
//
//  Created by Hamid Farooq on 17/01/2021.
//

import XCTest

extension XCUIElement {
    
    func tapIfElementExists() {
        if exists {
            tap()
        }
    }    
}


