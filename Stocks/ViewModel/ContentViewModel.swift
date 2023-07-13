//
//  ContentViewModel.swift
//  Stocks
//
//  Created by Cameron on 7/12/23.
//

import Foundation

class ContentViewModel: ObservableObject {
    
    @Published var stocks: [Stock] = [];
    let networkService: PortfolioFetchProtocol
    
    init(service: PortfolioFetchProtocol = NetworkService()) {
        self.networkService = service;
    }
    
    @MainActor func fetchData() {
        
        Task {
            do {
                let data = try await self.networkService.fetchPortfolio();
                self.stocks = data.stocks;
            }
            catch {
                print(error.localizedDescription);
            }
        }
    }
}
