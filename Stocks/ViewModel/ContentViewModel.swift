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
    
    @Published var stocks: [Stock_API] = [];
    @Published var viewState: ViewState = .loading
    private var loadedStocks: [Stock_API] = []
    
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
                self.updateViewState()
            }
            catch {
                print(error.localizedDescription);
                self.viewState = .error
            }
        }
    }
    
    func searchLoadedStocks(searchText: String) {
        
        if(self.viewState == .error) {
            return;
        }
        
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
