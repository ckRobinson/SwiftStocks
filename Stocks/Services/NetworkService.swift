//
//  NetworkService.swift
//  Stocks
//
//  Created by Cameron on 7/12/23.
//

import Foundation

enum APIError: Error {
    case invalidUrl
    case invalidResponse
}

enum APINetworkState: String {
    case valid = "https://storage.googleapis.com/cash-homework/cash-stocks-api/portfolio.json"
    case malformed = "https://storage.googleapis.com/cash-homework/cash-stocks-api/portfolio_malformed.json"
    case empty = "https://storage.googleapis.com/cash-homework/cash-stocks-api/portfolio_empty.json"
}

protocol PortfolioFetchProtocol {
    func fetchPortfolio() async throws -> PortfolioResponse;
}

class NetworkService: PortfolioFetchProtocol {
    
    let urlString: String
    init(networkState: APINetworkState = .valid) {
        self.urlString = networkState.rawValue
    }
    init(urlString: String) {
        self.urlString = urlString;
    }
    
    func fetchPortfolio() async throws -> PortfolioResponse {
     
        guard let url = URL(string: self.urlString) else {
            throw APIError.invalidUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url);
        guard let resp = response as? HTTPURLResponse,
              resp.statusCode == 200 else {
            print("Got response status \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
            throw APIError.invalidResponse
        }

        return try JSONDecoder().decode(PortfolioResponse.self, from: data)
    }
}
