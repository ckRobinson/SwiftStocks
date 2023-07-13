//
//  StocksTests.swift
//  StocksTests
//
//  Created by Cameron on 7/12/23.
//

import XCTest
import Combine
@testable import Stocks

final class StocksTests: XCTestCase {

    var cancellables = Set<AnyCancellable>()
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        self.cancellables = []
    }

    /// Not sure if marking this as @MainActor is the right way to test an @MainActor function but it seems to work.
    @MainActor func test_ViewModelDecodes_Success() async throws {
        
        let exp = XCTestExpectation(description: "View Model fetch success.");
        let viewModel = ContentViewModel()
        viewModel.fetchData()
        
        viewModel.$stocks
            .sink { stocks in
                if stocks.count > 0 {
                    exp.fulfill()
                }
            }
            .store(in: &cancellables)

        await fulfillment(of: [exp], timeout: 10.0)
    }
    
    @MainActor func test_ViewModelDecodes_Failure() async throws {
        
        let exp = XCTestExpectation(description: "View Model fetch failure.");
        let viewModel = ContentViewModel(service: TestsNetworkService(fileName: .malformedData) )
        viewModel.fetchData()
        
        viewModel.$stocks
            .sink { stocks in
                if stocks.count == 0 {
                    exp.fulfill()
                }
            }
            .store(in: &cancellables)

        await fulfillment(of: [exp], timeout: 10.0)
    }

    
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
    case malformedData = "API_MalformedData"
}
