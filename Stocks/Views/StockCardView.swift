//
//  StockCardView.swift
//  Stocks
//
//  Created by Cameron on 7/14/23.
//

import SwiftUI

struct StockCardView: View {
    
    let stock: Stock
    init(stock: Stock) {
        self.stock = stock;
    }
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                Text(stock.ticker)
                    .fontWeight(.bold)
                Text(stock.name)
                    .font(.footnote)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()

            Text(stock.priceStringWithCurrency)
                .shadow(color: .black, radius: 0.1)
            
            Image(systemName: "chevron.forward")
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(UIColor.systemGray5))
        .cornerRadius(15)
    }
}

struct StockCardView_Previews: PreviewProvider {
    static var previews: some View {
        StockCardView(stock: Stock.mockData)
    }
}
