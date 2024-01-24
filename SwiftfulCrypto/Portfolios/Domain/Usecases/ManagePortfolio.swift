//
//  ManagePortfolio.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 1/1/24.
//

import Foundation

protocol ManagePortfolio {
    func callAsFunction(coinID: String, amount: Double) async
}
