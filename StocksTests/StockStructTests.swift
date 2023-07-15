//
//  StockStructTests.swift
//  StocksTests
//
//  Created by Cameron on 7/14/23.
//

import Foundation
import XCTest
@testable import Stocks

final class StockStructTests: XCTestCase {
    
    let stockData: Stock = Stock.mockData
    
    func test_currentPriceString() async throws {
        XCTAssert(stockData.currentPriceString == "8.44")
    }
    
    func test_priceStringWithCurrency() async throws {
        XCTAssert(stockData.priceStringWithCurrency == "$8.44")
    }
    
    func test_priceDateTime() async throws {
        XCTAssert(stockData.currentPriceDateTimeString == "Aug 20, 9:53 AM")
    }
}
