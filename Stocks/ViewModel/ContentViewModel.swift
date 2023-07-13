//
//  ContentViewModel.swift
//  Stocks
//
//  Created by Cameron on 7/12/23.
//

import Foundation

enum ViewState {
    case loading
    case emptyResults
    case loadedResults
    case error
}

class ContentViewModel: ObservableObject {
    
    @Published var stocks: [Stock] = [];
    @Published var viewState: ViewState = .loading
    
    let networkService: PortfolioFetchProtocol
    
    init(service: PortfolioFetchProtocol = NetworkService()) {
        self.networkService = service;
    }
    
    @MainActor func fetchData() {
        
        Task {
            do {
                let data = try await self.networkService.fetchPortfolio();
                self.stocks = data.stocks;
                self.viewState = .loadedResults
            }
            catch {
                print(error.localizedDescription);
                self.viewState = .error
            }
        }
    }
}
