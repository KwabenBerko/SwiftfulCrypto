//
//  MarketInfoFactory.swift
//  SwiftfulCryptoTests
//
//  Created by Kwabena Berko on 1/5/24.
//

import Foundation

struct MarketInfoFactory {
    
    static func makeMarketInfo(
        totalMarketCap: Double? = 2576156760966.8447,
        totalMarketVolume: Double? = 342253229813.7348,
        btcDominance: Double? = 42.56418169927073,
        marketCapChangePercentage24HUsd: Double = 0.5446264306552537
    ) -> MarketInfo {
        return MarketInfo(totalMarketCap: totalMarketCap, totalMarketVolume: totalMarketVolume, btcDominance: btcDominance, marketCapChangePercentage24HUsd: marketCapChangePercentage24HUsd)
    }
    
    static func makeNetworkMarketInfo(
        totalMarketCap: [String: Double] = ["usd": 2576156760966.8447],
        totalVolume: [String: Double] = ["usd": 342253229813.7348],
        marketCapPercentage: [String: Double] = ["btc": 42.56418169927073],
        marketCapChangePercentage24HUsd: Double = 0.5446264306552537
    ) -> NetworkMarketInfo {
        return NetworkMarketInfo(
            totalMarketCap: totalMarketCap,
            totalVolume: totalVolume,
            marketCapPercentage: marketCapPercentage,
            marketCapChangePercentage24HUsd: marketCapChangePercentage24HUsd
        )
    }
    
    static func makeNetworkMarketInfoResponse(
        data: NetworkMarketInfo? = makeNetworkMarketInfo()
    ) -> NetworkMarketInfoResponse {
        return NetworkMarketInfoResponse(data: data)
    }
}
