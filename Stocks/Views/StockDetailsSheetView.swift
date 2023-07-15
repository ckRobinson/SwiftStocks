//
//  StockDetailsSheetView.swift
//  Stocks
//
//  Created by Cameron on 7/14/23.
//

import SwiftUI

struct StockDetailsSheetView: View {
    
    let stockData: Stock
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text(stockData.ticker)
                        .font(.title3)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(stockData.name)
                        .font(.footnote)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .trailing) {
                    Text("Price per Share:")
                    Text(stockData.priceStringWithCurrency)
                        .fontWeight(.bold)
                }
                .font(.callout)
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack {
                Text("Current Investment:")
                    .font(.headline)
                Text("\(stockData.quantity) shares")
            }
            .padding(.top)
            
            Spacer()
            VStack(alignment: .trailing) {
                Text("Price Last Updated:")
                Text("\(stockData.currentPriceDateTimeString)")
            }
            .font(.footnote)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 25)
        .padding(.horizontal)
    }
}

struct StockDetailsSheetView_Previews: PreviewProvider {
    
    static var previews: some View {
        StockDetailsSheetPreviewWrapper()
    }
}

private struct StockDetailsSheetPreviewWrapper: View {
    let data = Stock.mockData
    @State var presenting = true;
    
    var body: some View {
        ZStack {
            BackgroundView()
        }
        .sheet(isPresented: $presenting) {
            StockDetailsSheetView(stockData: data)
                .presentationDetents([.fraction(0.33)])
                .presentationDragIndicator(.visible)
        }
    }
}
