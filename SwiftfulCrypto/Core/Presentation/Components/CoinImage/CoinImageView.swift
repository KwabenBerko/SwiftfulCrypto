//
//  CoinImageView.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 12/30/23.
//

import SwiftUI
import Kingfisher

struct CoinImageView: View {
    
    let imageURL: String
    
    init(imageURL: String) {
        self.imageURL = imageURL
    }
    
    var body: some View {
        ZStack {
            KFImage(URL(string: imageURL))
                .placeholder {
                    ProgressView()
                }
                .resizable()
                .scaledToFit()
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    let coin = CoinFactory.makeCoin()
    return CoinImageView(imageURL: coin.image)
        .padding()
}
