//
//  ContentViewModel.swift
//  Stocks
//
//  Created by Cameron on 7/12/23.
//

import Foundation

class ContentViewModel: ObservableObject {
    
    @Published var stocks: [Stock] = [];
    let networkService: NetworkService = NetworkService();
    
    @MainActor func fetchData() {
        
        Task {
            do {
                let data = try await self.networkService.fetchPortfolio();
                print(data);
            }
            catch {
                print(error.localizedDescription);
            }
        }
    }
}