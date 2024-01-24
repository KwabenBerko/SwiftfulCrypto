//
//  MarketDataModel.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 1/2/24.
//

import Foundation

struct MarketInfo: Equatable {
    let totalMarketCap, totalMarketVolume, btcDominance: Double?
    let marketCapChangePercentage24HUsd: Double
    
}

