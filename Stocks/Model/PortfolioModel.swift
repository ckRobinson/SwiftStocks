//
//  PortfolioModel.swift
//  Stocks
//
//  Created by Cameron on 7/12/23.
//

import Foundation

struct PortfolioResponse: Decodable {
    let stocks: [Stock_API]
}

struct Stock_API: Decodable, Identifiable {
    let id = UUID()
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
    
    static let mockData = Stock_API(ticker: "UA",
                                name: "Under Armour, Inc.",
                                currency: "USD",
                                currentPriceCents: 844,
                                quantity: nil,
                                currentPriceTimestamp: 1597942385)
}

struct Stock: Identifiable {
    let id = UUID()
    let ticker: String;
    let name: String;
    let quantity: Int;
    private let currentPriceCents: Int;
    var currentPriceString: String {
        String(format: "%0.2f", Float(self.currentPriceCents) / 100.0);
    }
    var priceStringWithCurrency: String {
        "\(self.currencySymbol)\(self.currentPriceString)"
    }
    
    private let currentPriceDateTime: Date
    var currentPriceDateTimeString: String {
        let formatter = DateFormatter();
        formatter.dateFormat = "MMM d, h:mm a";
        return formatter.string(from: self.currentPriceDateTime);
    }
    
    let currency: String;
    var currencySymbol: String = "$";
    
    init(stockData: Stock_API) {
        
        self.ticker = stockData.ticker;
        self.name = stockData.name;
        self.quantity = stockData.quantity ?? 0;
        self.currentPriceCents = stockData.currentPriceCents;
        
        self.currentPriceDateTime = Date(timeIntervalSince1970: Double(stockData.currentPriceTimestamp))
        
        self.currency = stockData.currency;
    }
    
    mutating func parseCurrencySymbol() {
        //TODO: Can setup switching currency symbol here.
    }
    
    static let mockData = Stock(stockData: Stock_API.mockData)
}
