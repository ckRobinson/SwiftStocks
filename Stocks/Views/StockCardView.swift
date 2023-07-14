//
//  StockCardView.swift
//  Stocks
//
//  Created by Cameron on 7/14/23.
//

import SwiftUI

enum StockPriceState {
    case rising;
    case falling;
}

private class StockCardViewModel {
    let stockData: Stock;
    let stockPriceState: StockPriceState;
    let stockPriceString: String;
    let currencySymbol: String;
    var stockStateImage: String;

    init(stockData: Stock) {
        self.stockData = stockData;
        self.stockPriceState = Int.random(in: 0...1) == 1 ? StockPriceState.rising : StockPriceState.falling;
        self.stockStateImage = "arrow.up";
        if self.stockPriceState == .falling { self.stockStateImage = "arrow.down"; }
        
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
                Image(systemName: viewModel.stockStateImage)
                    .fontWeight(.bold)
                Text("\(viewModel.currencySymbol)\(viewModel.stockPriceString)")
            }
            .stockStyle(viewModel.stockPriceState)
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
