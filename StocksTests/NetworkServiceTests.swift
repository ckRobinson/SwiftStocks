//
//  StocksTests.swift
//  StocksTests
//
//  Created by Cameron on 7/12/23.
//

import XCTest
import Combine
@testable import Stocks

final class NetworkServiceTests: XCTestCase {

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}
    
    func test_NetworkServiceDecode_Success() async throws {
        
        let service = NetworkService()
        let data = try await service.fetchPortfolio()
        XCTAssertTrue(data.stocks.count > 0)
    }
    
    func test_NetworkServiceDecode_Fail() async throws {
        
        let service = NetworkService(networkState: .malformed)
        do {
            let _ = try await service.fetchPortfolio()
        }
        catch {
            XCTAssertTrue(true)
            return;
        }
        XCTAssertTrue(false);
    }
    
    func test_NetworkServiceDecode_Empty() async throws {
        
        let service = NetworkService(networkState: .empty)
        let data = try await service.fetchPortfolio()
        XCTAssertTrue(data.stocks.count == 0);
    }
    
    func test_NetworkServiceDecode_BadUrl() async throws {
        
        let service = NetworkService(urlString: "Bad Url String")
        do {
            let _ = try await service.fetchPortfolio()
        }
        catch {
            if let error = error as? APIError, error == .invalidUrl {
                XCTAssertTrue(true);
                return;
            }
        }
        XCTAssert(false);
    }
}
