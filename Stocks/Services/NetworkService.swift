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

class NetworkService {
    
    func fetchPortfolio() async throws -> PortfolioResponse {
     
        guard let url = URL(string: "https://storage.googleapis.com/cash-homework/cash-stocks-api/portfolio.json") else {
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
