//
//  CoinInfoFactory.swift
//  SwiftfulCryptoTests
//
//  Created by Kwabena Berko on 1/5/24.
//

import Foundation

struct CoinInfoFactory {
    
    static func makeCoinInfo(
        id: String = "bitcoin",
        blockTimeInMinutes: Int = 10,
        hashingAlgorithm: String? = "SHA-256",
        description: Description? = Description(
            en: "Bitcoin is the first successful internet money based on peer-to-peer technology."
        ),
        links: Links? = Links(
            homepage: "http://www.bitcoin.org",
            subredditURL: "https://www.reddit.com/r/Bitcoin/"
        )
    ) -> CoinInfo {
        return CoinInfo(id: id, blockTimeInMinutes: blockTimeInMinutes, hashingAlgorithm: hashingAlgorithm, description: description, links: links)
    }
    
    static func makeNetworkCoinInfo(
        id: String = "bitcoin",
        blockTimeInMinutes: Int? = 10,
        hashingAlgorithm: String? = "SHA-256",
        description: NetworkDescription? = NetworkDescription(
            en: "Bitcoin is the first successful internet money based on peer-to-peer technology."
        ),
        links: NetworkLinks? = NetworkLinks(
            homepage: ["http://www.bitcoin.org"],
            subredditURL: "https://www.reddit.com/r/Bitcoin/"
        )
    ) -> NetworkCoinInfo {
        return NetworkCoinInfo(id: id, blockTimeInMinutes: blockTimeInMinutes, hashingAlgorithm: hashingAlgorithm, description: description, links: links)
    }
}
