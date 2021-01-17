//
//  CurrencyConvertorTests.swift
//  CurrencyConvertorTests
//
//  Created by Hamid Farooq on 14/01/2021.
//

import XCTest
@testable import Toast
@testable import DropDown
@testable import ProgressHUD
@testable import CurrencyConvertor

class CurrencyConvertorTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let currencyUSD = "USD"
        let currencyCodeUSD = currencyUSD.currencyCode
        XCTAssertTrue(currencyCodeUSD == "USD")
        
        let currencyAED = "USDAED" // This is the format is in response of API call call from https://currencylayer.com/
        let currencyCodeAED = currencyAED.currencyCode
        XCTAssertTrue(currencyCodeAED == "AED")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testCurrency() {
        
    }
}
