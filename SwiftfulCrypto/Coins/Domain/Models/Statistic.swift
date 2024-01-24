//
//  StatisticModel.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 12/30/23.
//

import Foundation

enum StatisticTitle {
    case totalMarketCap
    case totalMarketVolume
    case btcDominance
    case portfolioValue
    case currentPrice
    case marketCapitilization
    case rank
    case volume
    case high24
    case low24
    case priceChange24H
    case marketCapChange24H
    case blockTime
    case hashingAlgorithm
}

enum StatisticValue: Equatable {
    case amount(_ amount: Double)
    case text(_ text: String)
}

struct Statistic: Equatable {
    let title: StatisticTitle
    let value: StatisticValue?
    let percentageChange: Double?
    
    init(
        title: StatisticTitle,
        value: StatisticValue?,
        percentageChange: Double? = nil
    ){
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
    }
}
