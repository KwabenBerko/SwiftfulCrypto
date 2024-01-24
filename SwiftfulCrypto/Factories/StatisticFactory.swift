//
//  StatisticFactory.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 1/11/24.
//

import Foundation

struct StatisticFactory {
    private init() {}
    
    static func makeStatistic(
        title: StatisticTitle = .currentPrice,
        value: StatisticValue? = .amount(42000),
        percentageChange: Double? = nil
    ) -> Statistic {
        return Statistic(title: title, value: value, percentageChange: percentageChange)
    }
    
    static func makeStatisticViewItem(
        statistic: Statistic = makeStatistic(),
        formattedValue: String = "$42,000"
    ) -> StatisticViewitem {
        return StatisticViewitem(statistic: statistic, formattedValue: formattedValue)
    }
}
