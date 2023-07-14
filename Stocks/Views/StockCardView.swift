//
//  StockCardView.swift
//  Stocks
//
//  Created by Cameron on 7/14/23.
//

import SwiftUI

private class StockCardViewModel {
    let stockData: Stock;
    let stockPriceRising: Bool;
    let stockPriceString: String;
    let currencySymbol: String;
    init(stockData: Stock) {
        self.stockData = stockData;
        self.stockPriceRising = Int.random(in: 0...1) == 1;
        
        self.stockPriceString = String(format: "%0.2f", Float(stockData.currentPriceCents) / 100.0);
        self.currencySymbol = "$";
    }
}

struct StockCardView: View {
    
    private let viewModel: StockCardViewModel
    init(stockData: Stock) {
        self.viewModel = StockCardViewModel(stockData: stockData);
    }
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                Text(viewModel.stockData.ticker)
                Text(viewModel.stockData.name)
                    .font(.footnote)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            HStack {
                if viewModel.stockPriceRising {
                    Image(systemName: "arrow.up")
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    Text("\(viewModel.currencySymbol)\(viewModel.stockPriceString)")
                        .foregroundColor(.green)
                }
                else {
                    Image(systemName: "arrow.down")
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                    Text("\(viewModel.currencySymbol)\(viewModel.stockPriceString)")
                        .foregroundColor(.red)
                }
            }
            .shadow(color: .black, radius: 0.1)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(UIColor.systemGray5))
        .cornerRadius(15)
    }
}

struct StockCardView_Previews: PreviewProvider {
    static var previews: some View {
        StockCardView(stockData: Stock.mockData)
    }
}
