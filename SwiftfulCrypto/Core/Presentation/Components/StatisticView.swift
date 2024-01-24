//
//  StatisticView.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 12/30/23.
//

import SwiftUI

struct StatisticView: View {
    
    let item: StatisticViewitem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(item.statistic.title.localizedString)
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
            
            Text(item.formattedValue)
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
            
            HStack(spacing: 4) {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(
                        Angle(degrees: (item.statistic.percentageChange ?? 0) >= 0 ? 0 : 180)
                    )
                
                
                Text(item.statistic.percentageChange?.asPercentString() ?? "")
                    .font(.caption)
                    .bold()
            }
            .foregroundStyle(
                (item.statistic.percentageChange ?? 0) >= 0 ? Color.theme.green : Color.theme.red
            )
            .opacity(item.statistic.percentageChange == nil ? 0.0 : 1.0)
        }
    }
}

//#Preview("Stat 1", traits: .sizeThatFitsLayout) {
//    StatisticView(stat: DeveloperPreview.instance.stat1)
//}
//
//#Preview("Stat 2", traits: .sizeThatFitsLayout) {
//    StatisticView(stat: DeveloperPreview.instance.stat2)
//}
//
//#Preview("Stat 3", traits: .sizeThatFitsLayout) {
//    StatisticView(stat: DeveloperPreview.instance.stat3)
//        .preferredColorScheme(.dark)
//}

private extension StatisticTitle {
    var localizedString: String {
        switch self {
        case .totalMarketCap:
            return "Market Cap"
        case .totalMarketVolume:
            return "24h Volume"
        case .btcDominance:
            return "BTC Dominance"
        case .portfolioValue:
            return "Portfolio Value"
        case .currentPrice:
            return "Current Price"
        case .marketCapitilization:
            return "Market Capitilization"
        case .rank:
            return "Rank"
        case .volume:
            return "Volume"
        case .high24:
            return "24h High"
        case .low24:
            return "24h Low"
        case .priceChange24H:
            return "24h Price Change"
        case .marketCapChange24H:
            return "24h Market Cap Change"
        case .blockTime:
            return "Block Time"
        case .hashingAlgorithm:
            return "Hashing Algorithm"
        }
    }
}

//extension Statistic {
//    var formattedValue: String {
//        switch self.value {
//        case .amount(let amount):
//            return "\(amount)"
//        case .text(let text):
//            return text
//        case .none:
//            return "n/a"
//        }
//    }
//}
