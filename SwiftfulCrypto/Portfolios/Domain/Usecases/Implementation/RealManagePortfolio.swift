//
//  RealManagePortfolioEntry.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 1/1/24.
//

import Foundation

class RealManagePortfolio: ManagePortfolio {
    private let repository: PortfolioRepository
    
    init(repository: PortfolioRepository) {
        self.repository = repository
    }
    
    func callAsFunction(coinID: String, amount: Double) async {
        if let portfolio = await repository.getPortfolio(coinID: coinID) {
            if amount > 0 {
                await repository.updatePortfolio(coinID: portfolio.coinID, amount: amount)
            } else {
                await repository.deletePortfolio(coinID: portfolio.coinID)
            }
        } else {
            await repository.createPortfolio(coinID: coinID, amount: amount)
        }
    }
}
