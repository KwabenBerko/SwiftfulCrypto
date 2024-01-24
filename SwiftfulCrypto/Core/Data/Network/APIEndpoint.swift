//
//  APIEndpoints.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 1/4/24.
//

import Foundation

struct APIEndpoint {
    private static let baseURL = "https://api.coingecko.com"
    
    private init(){}
    
    static func coins() -> String {
        return "\(baseURL)/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h"
    }
    
    static func coinInfo(coinID: String) -> String {
        return "\(baseURL)/api/v3/coins/\(coinID)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false"
    }
    
    static func marketInfo() -> String {
        return "\(baseURL)/api/v3/global"
    }
}
