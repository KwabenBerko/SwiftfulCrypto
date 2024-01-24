//
//  CoinEntityToCoinMapper.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 1/5/24.
//

import Foundation
import CoreData

struct CoinMappers {
    
    private init(){}
    
    static func mapToEntity(context: NSManagedObjectContext, _ input: NetworkCoin?) -> CoinEntity? {
        
        guard let input = input
        else {
            return nil
        }
        
        var sparklineIn7D: String? = nil
        if let sparklineIn7DPrices = input.sparklineIn7D?.price {
            let encoder = JSONEncoder()
            let data = (try? encoder.encode(sparklineIn7DPrices)) ?? Data.empty
            sparklineIn7D = String(data: data, encoding: .utf8)
        }
        
        let entity = CoinEntity(context: context)
        
        entity.coinID = input.id
        entity.name = input.name
        entity.symbol = input.symbol
        entity.ath = input.ath ?? 0
        entity.athChangePercentage = input.athChangePercentage ?? 0
        entity.athDate = input.athDate
        entity.atl = input.atl ?? 0
        entity.atlChangePercentage = input.atlChangePercentage ?? 0
        entity.atlDate = input.atlDate
        entity.circulatingSupply = input.circulatingSupply ?? 0
        entity.currentHoldings = 0
        entity.currentPrice = input.currentPrice
        entity.fullyDilutedValuation = input.fullyDilutedValuation ?? 0
        entity.high24H = input.high24H ?? 0
        entity.low24H = input.low24H ?? 0
        entity.imageURL = input.image
        entity.lastUpdated = input.lastUpdated
        entity.marketCap = input.marketCap ?? 0
        entity.marketCapChange24H = input.marketCapChange24H ?? 0
        entity.marketCapChangePercentage24H = input.marketCapChangePercentage24H ?? 0
        entity.marketCapRank = input.marketCapRank ?? 0
        entity.maxSupply = input.maxSupply ?? 0
        entity.priceChange24H = input.priceChange24H ?? 0
        entity.priceChangePercentage24H = input.priceChangePercentage24H ?? 0
        entity.priceChangePercentage24HInCurrency = input.priceChangePercentage24HInCurrency ?? 0
        entity.sparklineIn7D = sparklineIn7D
        entity.totalSupply = input.totalSupply ?? 0
        entity.totalVolume = input.totalVolume ?? 0
        
        return entity
    }
    
    static func mapToCoin(input: CoinEntity?) -> Coin? {
        guard let input = input,
              let id = input.coinID,
              let symbol = input.symbol,
              let name = input.name
        else {
            return nil
        }
        
        let decoder = JSONDecoder()
        let data = input.sparklineIn7D?.data(using: .utf8) ?? Data.empty
        let prices = (try? decoder.decode([Double].self, from: data)) ?? []
        let sparklineIn7D = SparklineIn7D(prices: prices)
        
        let imageURL = input.imageURL ?? ""
        let high24H = input.high24H == 0 ? nil : input.high24H
        let low24H = input.low24H == 0 ? nil : input.low24H
        let priceChange24H = input.priceChange24H == 0 ? nil : input.priceChange24H
        let athDate = input.athDate.flatMap { Date(coinGeckoString: $0) }
        let atlDate = input.atlDate.flatMap { Date(coinGeckoString: $0) }
        let lastUpdated = input.lastUpdated.flatMap { Date(coinGeckoString: $0) }
        
        return Coin(id: id, symbol: symbol, name: name, image: imageURL, currentPrice: input.currentPrice, marketCap: input.marketCap, marketCapRank: input.marketCapRank, fullyDilutedValuation: input.fullyDilutedValuation, totalVolume: input.totalVolume, high24H: high24H, low24H: low24H, priceChange24H: priceChange24H, priceChangePercentage24H: input.priceChangePercentage24H, marketCapChange24H: input.marketCapChange24H, marketCapChangePercentage24H: input.marketCapChangePercentage24H, circulatingSupply: input.circulatingSupply, totalSupply: input.totalSupply, maxSupply: input.maxSupply, ath: input.ath, athChangePercentage: input.athChangePercentage, athDate: athDate, atl: input.atl, atlChangePercentage: input.atlChangePercentage, atlDate: atlDate, lastUpdated: lastUpdated, sparklineIn7D: sparklineIn7D, priceChangePercentage24HInCurrency: input.priceChangePercentage24HInCurrency, currentHoldings: input.currentHoldings)
    }
    
    static func mapToCoinInfo(input: NetworkCoinInfo?) -> CoinInfo? {
        guard let input = input
        else {
            return nil
        }
        
        let blockTimeInMinutes = input.blockTimeInMinutes ?? 0
        let description = input.description.map {
            Description(en: $0.en)
        }
        let links = input.links.map {
            Links(homepage: $0.homepage?.first, subredditURL: $0.subredditURL)
        }
        
        return CoinInfo(id: input.id, blockTimeInMinutes: blockTimeInMinutes, hashingAlgorithm: input.hashingAlgorithm, description: description, links: links)
    }
}
