//
//  CoinLogoView.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 12/30/23.
//

import SwiftUI

struct CoinLogoView: View {
    
    let coin: Coin
    
    var body: some View {
        VStack {
            CoinImageView(imageURL: coin.image)
                .frame(width: 50, height: 50)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text(coin.name)
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview("Light", traits: .sizeThatFitsLayout) {
    let coin = CoinFactory.makeCoin()
    return CoinLogoView(coin: coin)
}

#Preview("Dark", traits: .sizeThatFitsLayout) {
    let coin = CoinFactory.makeCoin()
    return CoinLogoView(coin: coin)
        .preferredColorScheme(.dark)
}
