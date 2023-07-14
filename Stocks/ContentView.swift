//
//  ContentView.swift
//  Stocks
//
//  Created by Cameron on 7/12/23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ContentViewModel();
    @State var searchText: String = "";
    var body: some View {
        
        NavigationStack {
            ZStack {
                switch(viewModel.viewState) {
                case .loading:
                    loadingView
                case .loadedResults:
                    ScrollView {
                        ForEach(self.viewModel.stocks, id: \.self) { stock in
                            
                            StockCardView(stockData: stock)
                                .padding(.bottom)
                            
                        }
                    }
                case .emptyResults:
                    emptyResults
                case .error:
                    EmptyView()
                }
            }
            .padding()
        }
        .onAppear() {
            viewModel.fetchData()
        }
        .searchable(text: $searchText, prompt: "Search")
        .onChange(of: searchText, perform: { value in
            viewModel.searchLoadedStocks(searchText: value);
        })
    }
    
    var loadingView: some View {
        ProgressView()
    }
    
    var emptyResults: some View {
        Text("No results found.")
    }
}

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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
