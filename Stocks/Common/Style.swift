//
//  Style.swift
//  Stocks
//
//  Created by Cameron on 7/14/23.
//

import SwiftUI

/// https://www.swiftbysundell.com/tips/adding-swiftui-viewbuilder-to-functions/
extension View {
    @ViewBuilder func stockStyle(_ state: StockPriceState) -> some View {
        switch state {
        case .rising:
            self.foregroundColor(.green)
        case .falling:
            self.foregroundColor(.red)
        }
    }
}
