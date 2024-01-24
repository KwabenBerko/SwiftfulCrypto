//
//  Portfolio.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 1/1/24.
//

import Foundation

struct Portfolio: Equatable {
    let coinID: String
    let amount: Double
    
    func updateAmount(amount: Double) -> Portfolio {
        return Portfolio(coinID: self.coinID, amount: amount)
    }
}
