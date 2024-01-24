//
//  GetCoinDetailWithStatistics.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 1/6/24.
//

import Foundation
import Combine

protocol GetCoinDetail {
    func callAsFunction(coinID: String) -> AnyPublisher<CoinDetail?, Never>
}
