//
//  CoinRowView.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 12/30/23.
//

import SwiftUI

struct CoinRowView: View {
    
    let coin: Coin
    let showHoldings: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            leftColumn
            
            Spacer()
            
            if showHoldings {
                centerColumn
            }
            
            rightColumn
        }
        .font(.subheadline)
        .background(Color.theme.background.opacity(0.001))
    }
}

#Preview("Light", traits: .sizeThatFitsLayout) {
    CoinRowView(
        coin: CoinFactory.makeCoin(),
        showHoldings: true
    )
}

#Preview("Dark", traits: .sizeThatFitsLayout) {
    CoinRowView(
        coin: CoinFactory.makeCoin(),
        showHoldings: true
    )
    .preferredColorScheme(.dark)
}

extension CoinRowView {
    private var leftColumn: some View {
        HStack(spacing: 0) {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
                .frame(minWidth: 30)
            
            CoinImageView(imageURL: coin.image)
                .frame(width: 30, height: 30)
            
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
                .foregroundStyle(Color.theme.accent)
        }
    }
    
    private var centerColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentHoldingsValue.asCurrencyWith6Decimals())
                .bold()
            
            Text(coin.currentHoldings.asNumberString())
        }
        .foregroundStyle(Color.theme.accent)
    }
    
    private var rightColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.asCurrencyWith2Decimals())
                .bold()
                .foregroundStyle(Color.theme.accent)
            
            Text(coin.priceChangePercentage24H.asPercentString())
                .foregroundStyle(
                    coin.priceChangePercentage24H >= 0 ? Color.theme.green :
                        Color.theme.red
                )
        }
        .frame(
            width: UIScreen.main.bounds.width / 3.5,
            alignment: .trailing
        )
    }
}
