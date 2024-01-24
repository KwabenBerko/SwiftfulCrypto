//
//  GetMarketInfo.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 1/2/24.
//

import Foundation
import Combine

protocol GetMarketInfo {
    func callAsFunction() -> AnyPublisher<MarketInfo?, Never>
}
