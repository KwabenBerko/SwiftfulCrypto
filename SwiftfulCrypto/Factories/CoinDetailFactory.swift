//
//  CoinDetailFactory.swift
//  SwiftfulCryptoTests
//
//  Created by Kwabena Berko on 1/7/24.
//

import Foundation

struct CoinDetailFactory {
    private init() { }
    
    static func makeCoinDetail(
        coin: Coin = CoinFactory.makeCoin(),
        info: CoinInfo = CoinInfoFactory.makeCoinInfo(),
        statistics: Statistics = Statistics(overview: [], additional: [])
    ) -> CoinDetail {
        return CoinDetail(
            coin: coin,
            info: info,
            statistics: statistics
        )
    }
}
