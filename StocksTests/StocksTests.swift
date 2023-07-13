//
//  StocksTests.swift
//  StocksTests
//
//  Created by Cameron on 7/12/23.
//

import XCTest
@testable import Stocks

final class StocksTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_APIModelDecode_Success() async throws {
        
        let service = NetworkService()
        let data = try await service.fetchPortfolio()
        XCTAssertTrue(data.stocks.count > 0)
    }
    
    func test_APIModelDecode_Fail() async throws {
        
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
    
    func test_APIModelDecode_Empty() async throws {
        
        let service = NetworkService(networkState: .empty)
        let data = try await service.fetchPortfolio()
        XCTAssertTrue(data.stocks.count == 0);
    }
    
    func test_APIModelDecode_BadUrl() async throws {
        
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
    
    func test_FileModelDecode_Success() async throws {
        
        let service = TestsNetworkService(fileName: .apiSuccessData)
        let data = try await service.fetchPortfolio()
        XCTAssertTrue(data.stocks.count > 0);
    }
}

class TestsNetworkService: PortfolioFetchProtocol {
    
    let fileName: TestFileName;
    init(fileName: TestFileName) {
        self.fileName = fileName;
    }
    
    private func loadMockData(_ file: String) -> URL? {
        
        print(file);
        
        let bundle = Bundle(for: type(of: self))
        let url = bundle.url(forResource: file, withExtension: "json")
        return url;
    }
    
    func fetchPortfolio() async throws -> PortfolioResponse {
        
        guard let url = self.loadMockData(self.fileName.rawValue) else { throw APIError.invalidUrl }
        let data = try! Data(contentsOf: url);
        return try JSONDecoder().decode(PortfolioResponse.self, from: data)
    }
}

enum TestFileName: String {
    case apiSuccessData = "API_SuccessData"
}
