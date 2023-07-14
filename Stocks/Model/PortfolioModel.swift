//
//  PortfolioModel.swift
//  Stocks
//
//  Created by Cameron on 7/12/23.
//

import Foundation

struct PortfolioResponse: Decodable {
    let stocks: [Stock]
}

struct Stock: Decodable, Hashable {
    let ticker: String
    let name: String
    let currency: String
    let currentPriceCents: Int
    let quantity: Int?
    let currentPriceTimestamp: Int

    enum CodingKeys: String, CodingKey {
        case ticker
        case name
        case currency
        case currentPriceCents = "current_price_cents"
        case quantity
        case currentPriceTimestamp = "current_price_timestamp"
    }
    
    static let mockData = Stock(ticker: "UA",
                                name: "Under Armour, Inc.",
                                currency: "USD",
                                currentPriceCents: 844,
                                quantity: nil,
                                currentPriceTimestamp: 1597942385)
}
