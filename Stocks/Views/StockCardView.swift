//
//  StockCardView.swift
//  Stocks
//
//  Created by Cameron on 7/14/23.
//

import SwiftUI

struct StockCardView: View {
    
    let stockData: Stock;
    var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                Text(stockData.ticker)
                Text(stockData.name)
                    .font(.footnote)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            VStack {
                if( Int.random(in: 0...1) == 0) {
                    Text("$\(stockData.currentPriceCents)")
                        .foregroundColor(.red)
                        .shadow(color: .black, radius: 0.1)
                }
                else {
                    Text("$\(stockData.currentPriceCents)")
                        .foregroundColor(.green)
                        .shadow(color: .black, radius: 0.1)
                }
            }
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
