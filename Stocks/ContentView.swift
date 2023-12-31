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
    @State var isPresenting: Stock? = nil;
    var body: some View {
        
        NavigationStack {
            ZStack {
                BackgroundView()
                    .ignoresSafeArea(.all)
                
                VStack {
                    switch(viewModel.viewState) {
                    case .loading:
                        loadingView
                    case .loadedResults:
                        ScrollView {
                            ForEach(self.viewModel.stocks) { stock in
                                
                                Button(action: {
                                    self.isPresenting = stock;
                                }, label:{
                                    StockCardView(stock: stock)
                                        .padding(.bottom)
                                })
                                .foregroundColor(.black)
                            }
                            .sheet(item: $isPresenting) { stock in
                                
                                StockDetailsSheetView(stockData: stock)
                                    .presentationDetents([.fraction(0.33)])
                                    .presentationDragIndicator(.visible)
                            }
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
            .tint(.white)
    }
    
    var emptyResults: some View {
        Text("No results found.")
            .foregroundColor(.white)
    }
    
    var errorLoading: some View {
        Text("Could not load data. Please try again later.")
            .foregroundColor(.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
