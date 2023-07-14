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
                BackgroundView()
                    .ignoresSafeArea(.all)
                
                ScrollView {
                    switch(viewModel.viewState) {
                    case .loading:
                        loadingView
                    case .loadedResults:
                        ForEach(self.viewModel.stocks, id: \.self) { stock in
                            
                            StockCardView(stockData: stock)
                                .padding(.bottom)
                        }
                    case .emptyResults:
                        emptyResults
                    case .error:
                        errorLoading
                    }
                }
                .padding()
            }
            .navigationTitle("Stocks")
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
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
    
    var errorLoading: some View {
        Text("Could not load data. Please try again later.")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
