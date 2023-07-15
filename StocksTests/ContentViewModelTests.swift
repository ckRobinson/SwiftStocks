//
//  ContentViewModelTests.swift
//  StocksTests
//
//  Created by Cameron on 7/14/23.
//

import Foundation
import XCTest
import Combine
@testable import Stocks

final class ContentViewModelTests: XCTestCase {

    var cancellables = Set<AnyCancellable>()
    override func setUpWithError() throws {}

    override func tearDownWithError() throws {
        self.cancellables = [];
    }

    func test_ViewModelDecodes_Success() async throws {
        
        let exp = XCTestExpectation(description: "View Model fetch success.");
        let viewModel = ContentViewModel(service: FilePortfolioService(fileName: .apiSuccessData) )
        await viewModel.fetchData()

        viewModel.$stocks
            .dropFirst()
            .sink { stocks in
                XCTAssert(stocks.count > 0)
                exp.fulfill()
            }
            .store(in: &cancellables)

        await fulfillment(of: [exp], timeout: 10.0)
    }
    
    func test_ViewModelDecodes_Failure() async throws {
        
        let exp = XCTestExpectation(description: "View Model fetch failure.");
        let viewModel = ContentViewModel(service: FilePortfolioService(fileName: .malformedData) )
        await viewModel.fetchData()
        
        viewModel.$viewState
            .dropFirst()
            .sink { state in
                XCTAssert(state == .error)
                exp.fulfill()
            }
            .store(in: &cancellables)

        await fulfillment(of: [exp], timeout: 10.0)
    }
    
    func test_ViewModel_SearchOnError() async throws {
        
        let exp = XCTestExpectation(description: "View Model fetch failure.");
        let viewModel = ContentViewModel(service: FilePortfolioService(fileName: .malformedData) )
        await viewModel.fetchData()
        
        viewModel.$viewState
            .dropFirst()
            .sink { state in
                XCTAssert(state == .error)
                exp.fulfill()
            }
            .store(in: &cancellables)

        await fulfillment(of: [exp], timeout: 10.0)
        
        viewModel.searchLoadedStocks(searchText: "asdfffdsaasdfffdsa")
        XCTAssert(viewModel.viewState == .error)
    }
    
    func test_ViewModelEmptySearch_Success() async throws {
        
        let exp = XCTestExpectation(description: "View Model fetch success.");
        let viewModel = ContentViewModel(service: FilePortfolioService(fileName: .apiSuccessData) )
        await viewModel.fetchData()
        
        viewModel.$stocks
            .dropFirst()
            .sink { stocks in
                XCTAssert(stocks.count > 0)
                exp.fulfill()
            }
            .store(in: &cancellables)

        await fulfillment(of: [exp], timeout: 10.0)
        
        let numStocks = viewModel.stocks.count;
        viewModel.searchLoadedStocks(searchText: "")
        XCTAssert(numStocks == viewModel.stocks.count)
    }
    
    func test_ViewModelSearch_NoResults() async throws {
        
        let exp = XCTestExpectation(description: "View Model fetch success.");
        let viewModel = ContentViewModel(service: FilePortfolioService(fileName: .apiSuccessData) )
        await viewModel.fetchData()
        
        viewModel.$stocks
            .dropFirst()
            .sink { stocks in
                exp.fulfill()
            }
            .store(in: &cancellables)

        await fulfillment(of: [exp], timeout: 10.0)
        
        viewModel.searchLoadedStocks(searchText: "asdfffdsaasdfffdsa")
        XCTAssert(viewModel.viewState == .emptyResults)
    }
    
    func test_ViewModelSearch_OneResults() async throws {
        
        let exp = XCTestExpectation(description: "View Model fetch success.");
        let viewModel = ContentViewModel(service: FilePortfolioService(fileName: .apiSuccessData) )
        await viewModel.fetchData()
        
        viewModel.$stocks
            .dropFirst()
            .sink { stocks in
                XCTAssert(stocks.count > 0)
                exp.fulfill()
            }
            .store(in: &cancellables)

        await fulfillment(of: [exp], timeout: 10.0)
        
        viewModel.searchLoadedStocks(searchText: "GSPC")
        XCTAssert(viewModel.stocks.count == 1)
    }
}

class FilePortfolioService: PortfolioFetchProtocol {
    
    let fileName: TestFileName;
    init(fileName: TestFileName) {
        self.fileName = fileName;
    }
    
    private func loadMockData(_ file: String) -> URL? {
        
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
