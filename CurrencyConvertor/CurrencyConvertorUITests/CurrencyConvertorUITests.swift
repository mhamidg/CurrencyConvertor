//
//  CurrencyConvertorUITests.swift
//  CurrencyConvertorUITests
//
//  Created by Hamid Farooq on 14/01/2021.
//

import XCTest
@testable import Toast
@testable import DropDown
@testable import ProgressHUD
@testable import CurrencyConvertor

class CurrencyConvertorUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        app = XCUIApplication()
        app.launch()
    
        continueAfterFailure = false
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func testSwitchCurrencyToAED() {
        app.launch()
        
        sleep(2.0)
        
        openCurrencySelectionDropdown()
        selectCurrencyFromDropdown(at: 0)
    }
    
    func testSwitchCurrencyToAUD() {
        app.launch()
        
        sleep(2.0)
        
        openCurrencySelectionDropdown()
        selectCurrencyFromDropdown(at: 7)
    }
}

extension CurrencyConvertorUITests {
    
    func openCurrencySelectionDropdown() {
        app.buttons.firstMatch.tapIfElementExists()
        sleep(0.5)
    }
    
    func selectCurrencyFromDropdown(at index: Int) {
        app.tables.firstMatch.cells.element(boundBy: index).tapIfElementExists()
        sleep(2.0)
    }
    
    func scrollTable(at index: Int) {
        let table = app.tables.firstMatch
        let cell = table.cells.element(boundBy: index)
        while !cell.exists {
            table.swipeUp()
        }
        
        sleep(2.0)
    }
}
