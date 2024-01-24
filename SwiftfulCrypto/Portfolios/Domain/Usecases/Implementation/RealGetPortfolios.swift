//
//  RealGetPortfolios.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 1/1/24.
//

import Foundation
import Combine

class RealGetPortfolios: GetPortfolios {
    
    private let portfolioRepository: PortfolioRepository
    private let coinRepository: CoinRepository
    
    init(
        portfolioRepository: PortfolioRepository,
        coinRepository: CoinRepository
    ){
        self.portfolioRepository = portfolioRepository
        self.coinRepository = coinRepository
    }
    
    func callAsFunction() -> AnyPublisher<[Coin], Never> {
        return coinRepository.coins
            .combineLatest(portfolioRepository.portfolios)
            .map(mapCoinsToPortfolioCoins)
            .eraseToAnyPublisher()
    }
    
    private func mapCoinsToPortfolioCoins(
        coins: [Coin],
        portfolios: [Portfolio]
    ) -> [Coin] {
        coins
            .compactMap { coin in
                guard let portfolio = portfolios.first(where: { $0.coinID == coin.id })
                else {
                    return nil
                }
                
                return coin.updateHoldings(amount: portfolio.amount)
            }
    }
}
