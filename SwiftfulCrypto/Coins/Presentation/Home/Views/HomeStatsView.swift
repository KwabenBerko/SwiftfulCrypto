//
//  HomeStatsView.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 12/30/23.
//

import SwiftUI

struct HomeStatsView: View {
    @Binding var statistics: [StatisticViewitem]
    @Binding var showPortfolio: Bool
  
    var body: some View {
        HStack {
            ForEach(statistics, id: \.statistic.title) { item in
                StatisticView(item: item)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(
            width: UIScreen.main.bounds.width,
            alignment: showPortfolio ? .trailing : .leading
        )
    }
}

#Preview("Light", traits: .sizeThatFitsLayout) {
    let statistic = StatisticFactory.makeStatisticViewItem()
    return HomeStatsView(
        statistics: .constant([statistic, statistic, statistic]),
        showPortfolio: .constant(false)
    )
}

#Preview("Dark", traits: .sizeThatFitsLayout) {
    let statistic = StatisticFactory.makeStatisticViewItem()
    return HomeStatsView(
        statistics: .constant([statistic, statistic, statistic]),
        showPortfolio: .constant(false)
    )
    .preferredColorScheme(.dark)
}
