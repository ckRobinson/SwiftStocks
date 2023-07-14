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
    private var loadedStocks: [Stock] = []
    
    let networkService: PortfolioFetchProtocol
    
    init(service: PortfolioFetchProtocol = NetworkService()) {
        self.networkService = service;
    }
    
    @MainActor func fetchData() {
        
        Task {
            do {
                let data = try await self.networkService.fetchPortfolio();
                self.stocks = data.stocks;
                self.loadedStocks = data.stocks;
                self.viewState = .loadedResults
            }
            catch {
                print(error.localizedDescription);
                self.viewState = .error
            }
        }
    }
    
    func searchLoadedStocks(searchText: String) {
        if(searchText == "") {
            
            self.stocks = self.loadedStocks;
        }
        else {
            
            self.stocks = self.loadedStocks.filter({ stock in
                return stock.ticker.lowercased().contains(searchText.lowercased()) ||
                stock.name.lowercased().contains(searchText.lowercased())
            })
        }
        self.updateViewState()
    }
    
    private func updateViewState() {
        if(self.stocks.count == 0) {
            self.viewState = .emptyResults
        }
        else {
            self.viewState = .loadedResults
        }
    }
}
