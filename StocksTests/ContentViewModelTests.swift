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
        let viewModel = ContentViewModel(service: TestsNetworkService(fileName: .apiSuccessData) )
        await viewModel.fetchData()

        viewModel.$stocks
            .sink { stocks in
                if stocks.count > 0 {
                    exp.fulfill()
                }
            }
            .store(in: &cancellables)

        await fulfillment(of: [exp], timeout: 10.0)
    }
    
    func test_ViewModelDecodes_Failure() async throws {
        
        let exp = XCTestExpectation(description: "View Model fetch failure.");
        let viewModel = ContentViewModel(service: TestsNetworkService(fileName: .malformedData) )
        await viewModel.fetchData()
        
        viewModel.$viewState
            .sink { state in
                if state == .error {
                    exp.fulfill()
                }
            }
            .store(in: &cancellables)

        await fulfillment(of: [exp], timeout: 10.0)
    }
    
    func test_ViewModel_SearchOnError() async throws {
        
        let exp = XCTestExpectation(description: "View Model fetch failure.");
        let viewModel = ContentViewModel(service: TestsNetworkService(fileName: .malformedData) )
        await viewModel.fetchData()
        
        viewModel.$viewState
            .sink { state in
                if state == .error {
                    exp.fulfill()
                }
            }
            .store(in: &cancellables)

        await fulfillment(of: [exp], timeout: 10.0)
        
        viewModel.searchLoadedStocks(searchText: "asdfffdsaasdfffdsa")
        XCTAssert(viewModel.viewState == .error)
    }
    
    func test_ViewModelEmptySearch_Success() async throws {
        
        let exp = XCTestExpectation(description: "View Model fetch success.");
        let viewModel = ContentViewModel(service: TestsNetworkService(fileName: .apiSuccessData) )
        await viewModel.fetchData()
        
        viewModel.$stocks
            .sink { stocks in
                if stocks.count > 0 {
                    exp.fulfill()
                }
            }
            .store(in: &cancellables)

        await fulfillment(of: [exp], timeout: 10.0)
        
        let numStocks = viewModel.stocks.count;
        viewModel.searchLoadedStocks(searchText: "")
        XCTAssert(numStocks == viewModel.stocks.count)
    }
    
    func test_ViewModelSearch_NoResults() async throws {
        
        let exp = XCTestExpectation(description: "View Model fetch success.");
        let viewModel = ContentViewModel(service: TestsNetworkService(fileName: .apiSuccessData) )
        await viewModel.fetchData()
        
        viewModel.$stocks
            .sink { stocks in
                if stocks.count > 0 {
                    exp.fulfill()
                }
            }
            .store(in: &cancellables)

        await fulfillment(of: [exp], timeout: 10.0)
        
        viewModel.searchLoadedStocks(searchText: "asdfffdsaasdfffdsa")
        XCTAssert(viewModel.viewState == .emptyResults)
    }
    
    func test_ViewModelSearch_OneResults() async throws {
        
        let exp = XCTestExpectation(description: "View Model fetch success.");
        let viewModel = ContentViewModel(service: TestsNetworkService(fileName: .apiSuccessData) )
        await viewModel.fetchData()
        
        viewModel.$stocks
            .sink { stocks in
                if(stocks.count > 0) {
                    exp.fulfill()
                }
            }
            .store(in: &cancellables)

        await fulfillment(of: [exp], timeout: 10.0)
        
        viewModel.searchLoadedStocks(searchText: "GSPC")
        XCTAssert(viewModel.stocks.count == 1)
    }
}
