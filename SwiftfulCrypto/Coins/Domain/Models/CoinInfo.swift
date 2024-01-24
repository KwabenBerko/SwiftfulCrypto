//
//  CoinInfo.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 1/4/24.
//

import Foundation

struct CoinInfo: Equatable {
    let id: String
    let blockTimeInMinutes: Int
    let hashingAlgorithm: String?
    let description: Description?
    let links: Links?
    
    var readableDescription: String? {
        return description?.en?.removingHTMLOccurences
    }
}

struct Links: Equatable {
    let homepage: String?
    let subredditURL: String?
}

struct Description: Equatable {
    let en: String?
}
