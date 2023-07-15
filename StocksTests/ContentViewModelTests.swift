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
        
        viewModel.$viewState
            .sink { state in
                if(state == .error) {
                    exp.fulfill()
                }
            }
            .store(in: &cancellables)

        await fulfillment(of: [exp], timeout: 10.0)
    }
    
    @MainActor func test_ViewModel_SearchOnError() async throws {
        
        let exp = XCTestExpectation(description: "View Model fetch failure.");
        let viewModel = ContentViewModel(service: TestsNetworkService(fileName: .malformedData) )
        viewModel.fetchData()
        
        viewModel.$viewState
            .sink { state in
                if(state == .error) {
                    exp.fulfill()
                }
            }
            .store(in: &cancellables)

        await fulfillment(of: [exp], timeout: 10.0)
        
        viewModel.searchLoadedStocks(searchText: "asdfffdsaasdfffdsa")
        XCTAssert(viewModel.viewState == .error)
    }
    
    @MainActor func test_ViewModelEmptySearch_Success() async throws {
        
        let exp = XCTestExpectation(description: "View Model fetch failure.");
        let viewModel = ContentViewModel(service: TestsNetworkService(fileName: .apiSuccessData) )
        viewModel.fetchData()
        
        viewModel.$stocks
            .sink { stocks in
                exp.fulfill()
            }
            .store(in: &cancellables)

        await fulfillment(of: [exp], timeout: 10.0)
        
        let numStocks = viewModel.stocks.count;
        viewModel.searchLoadedStocks(searchText: "")
        XCTAssert(numStocks == viewModel.stocks.count)
    }
    
    @MainActor func test_ViewModelSearch_NoResults() async throws {
        
        let exp = XCTestExpectation(description: "View Model Fetch.");
        let viewModel = ContentViewModel(service: TestsNetworkService(fileName: .apiSuccessData) )
        viewModel.fetchData()
        
        viewModel.$stocks
            .sink { stocks in
                if(stocks.count > 0) {
                    exp.fulfill()
                }
            }
            .store(in: &cancellables)

        await fulfillment(of: [exp], timeout: 10.0)
        
        viewModel.searchLoadedStocks(searchText: "asdfffdsaasdfffdsa")
        XCTAssert(viewModel.viewState == .emptyResults)
    }
    
    @MainActor func test_ViewModelSearch_OneResults() async throws {
        
        let exp = XCTestExpectation(description: "View Model Fetch.");
        let viewModel = ContentViewModel(service: TestsNetworkService(fileName: .apiSuccessData) )
        viewModel.fetchData()
        
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
