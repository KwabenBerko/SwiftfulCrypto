//
//  RealGetCoinDetailWithStatistics.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 1/6/24.
//

import Foundation
import Combine

class RealGetCoinDetail: GetCoinDetail {
    private let repository: CoinRepository
    
    init(repository: CoinRepository) {
        self.repository = repository
    }
    
    func callAsFunction(coinID: String) -> AnyPublisher<CoinDetail?, Never> {
        return repository.getCoin(coinID: coinID)
            .combineLatest(repository.getCoinInfo(coinID: coinID))
            .map { (coin, coinInfo) in
                guard let coin = coin,
                      let coinInfo = coinInfo
                else {
                    return nil
                }
                
                return CoinDetail(
                    coin: coin,
                    info: coinInfo,
                    statistics: self.createStatistics(coin: coin, coinInfo: coinInfo)
                )
            }
            .eraseToAnyPublisher()
    }
    
    private func createStatistics(coin: Coin, coinInfo: CoinInfo) -> Statistics {
        let currentPrice = Statistic(
            title: .currentPrice,
            value: .amount(coin.currentPrice),
            percentageChange: coin.priceChangePercentage24H
        )
        let marketCap = Statistic(
            title: .marketCapitilization,
            value: .amount(coin.marketCap),
            percentageChange: coin.marketCapChangePercentage24H
        )
        let rank = Statistic(
            title: .rank,
            value: .text("\(coin.rank)")
        )
        let volume = Statistic(
            title: .volume,
            value: .amount(coin.totalVolume)
        )
        
        let high24 = Statistic(
            title: .high24,
            value: coin.high24H.map { .amount($0) }
        )
        let low24 = Statistic(
            title: .low24,
            value: coin.low24H.map { .amount($0) }
        )
        let priceChange24 = Statistic(
            title: .priceChange24H,
            value: coin.priceChange24H.map { .amount($0) },
            percentageChange: coin.priceChangePercentage24H
        )
        let marketCapChange24 = Statistic(
            title: .marketCapChange24H,
            value: .amount(coin.marketCapChange24H),
            percentageChange: coin.marketCapChangePercentage24H
        )
        let blockTime = Statistic(
            title: .blockTime,
            value: coinInfo.blockTimeInMinutes == 0 ? nil : .text("\(coinInfo.blockTimeInMinutes)")
        )
        let hashingAlgorithm = Statistic(
            title: .hashingAlgorithm,
            value: coinInfo.hashingAlgorithm.map { .text($0) }
        )
        
        let overview = [currentPrice, marketCap, rank, volume]
        let additional = [high24, low24, priceChange24, marketCapChange24, blockTime, hashingAlgorithm]
        return Statistics(overview: overview, additional: additional)
    }
}
