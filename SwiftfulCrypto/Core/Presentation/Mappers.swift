//
//  Mappers.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 1/7/24.
//

import Foundation

func mapToViewItem(_ statistic: Statistic) -> StatisticViewitem {
    let formattedValue: String
    
    switch statistic.value {
    case .none:
        formattedValue = "n/a"
    case .some(let value):
        switch value {
        case .text(let text):
            formattedValue = text
        case .amount(let amount):
            switch statistic.title {
            case .currentPrice, .high24, .low24, .priceChange24H:
                formattedValue = amount.asCurrencyWith6Decimals()
            case .portfolioValue:
                formattedValue = amount.asCurrencyWith2Decimals()
            case .btcDominance:
                formattedValue = amount.asPercentString()
            default:
                formattedValue = "$\(amount.formattedWithAbbreviations())"
            }
        }
    }
    
    
    return StatisticViewitem(
        statistic: statistic,
        formattedValue: formattedValue
    )
}
