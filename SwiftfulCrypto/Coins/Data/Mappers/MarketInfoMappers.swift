//
//  MarketInfoMappers.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 1/5/24.
//

import Foundation

struct MarketInfoMappers {
    private init() {}
    
    static func mapToString(_ input: NetworkMarketInfoResponse?) -> String? {
        guard let input = input
        else {
            return nil
        }
        
        let encoder = JSONEncoder()
        let data = (try? encoder.encode(input)) ?? Data.empty
        return String(data: data, encoding: .utf8)
    }

    static func mapToNetwork(_ input: String) -> NetworkMarketInfoResponse? {
        let decoder = JSONDecoder()
        let data = input.data(using: .utf8) ?? Data.empty
        let network = try? decoder.decode(NetworkMarketInfoResponse.self, from: data)
        return network
    }

    static func mapToMarketInfo(_ input: NetworkMarketInfoResponse?) -> MarketInfo? {
        guard let input = input,
              let data = input.data
        else {
            return nil
        }
        
        let totaMarketCap = data.totalMarketCap["usd"]?.flatMap { $0 }
        let totalMarketVolume = data.totalVolume["usd"]?.flatMap { $0 }
        let btcDominance = data.marketCapPercentage["btc"]?.flatMap { $0 }
        
        return MarketInfo(
            totalMarketCap: totaMarketCap,
            totalMarketVolume: totalMarketVolume,
            btcDominance: btcDominance,
            marketCapChangePercentage24HUsd: data.marketCapChangePercentage24HUsd ?? 0
        )
    }

}
