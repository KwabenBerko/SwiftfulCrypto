//
//  CoinDetailWithStatistics.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 1/6/24.
//

import Foundation

struct CoinDetail: Equatable {
    let coin: Coin
    let info: CoinInfo
    let statistics: Statistics
}

struct Statistics: Equatable {
    let overview: [Statistic]
    let additional: [Statistic]
}
