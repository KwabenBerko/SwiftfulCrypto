//
//  CoinModel.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 1/2/24.
//

import Foundation


struct Coin: Identifiable, Equatable {
    let id, symbol, name: String
    let image: String
    let currentPrice: Double
    let marketCap, marketCapRank, fullyDilutedValuation: Double
    let totalVolume: Double
    let high24H, low24H: Double?
    let priceChange24H: Double?
    let priceChangePercentage24H: Double
    let marketCapChange24H: Double
    let marketCapChangePercentage24H: Double
    let circulatingSupply, totalSupply, maxSupply, ath: Double
    let athChangePercentage: Double
    let athDate: Date?
    let atl, atlChangePercentage: Double
    let atlDate: Date?
    let lastUpdated: Date?
    let sparklineIn7D: SparklineIn7D
    let priceChangePercentage24HInCurrency: Double
    let currentHoldings: Double
    
    func updateHoldings(amount: Double) -> Coin {
        return Coin(id: id, symbol: symbol, name: name, image: image, currentPrice: currentPrice, marketCap: marketCap, marketCapRank: marketCapRank, fullyDilutedValuation: fullyDilutedValuation, totalVolume: totalVolume, high24H: high24H, low24H: low24H, priceChange24H: priceChange24H, priceChangePercentage24H: priceChangePercentage24H, marketCapChange24H: marketCapChange24H, marketCapChangePercentage24H: marketCapChangePercentage24H, circulatingSupply: circulatingSupply, totalSupply: totalSupply, maxSupply: maxSupply, ath: ath, athChangePercentage: athChangePercentage, athDate: athDate, atl: atl, atlChangePercentage: atlChangePercentage, atlDate: atlDate, lastUpdated: lastUpdated, sparklineIn7D: sparklineIn7D, priceChangePercentage24HInCurrency: priceChangePercentage24HInCurrency, currentHoldings: amount)
    }
    
    var currentHoldingsValue: Double {
        return currentHoldings * currentPrice
    }
    
    var rank: Int {
        return Int(marketCapRank)
    }
}

struct SparklineIn7D: Equatable {
    let prices: [Double]
}
