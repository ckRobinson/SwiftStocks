//
//  BackgroundView.swift
//  Stocks
//
//  Created by Cameron on 7/14/23.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        LinearGradient(colors: [Color("DarkBlue"), Color("DarkPurple"), .black], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea(.all) 
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
