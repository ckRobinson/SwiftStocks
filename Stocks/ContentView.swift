//
//  ContentView.swift
//  Stocks
//
//  Created by Cameron on 7/12/23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ContentViewModel();
    
    var body: some View {
        ScrollView {
            ForEach(self.viewModel.stocks, id: \.self) { stock in
                
                Text(stock.ticker)
            }
        }
        .padding()
        .onAppear() {
            viewModel.fetchData()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
