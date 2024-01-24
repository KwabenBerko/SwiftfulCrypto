//
//  GetCoinInfo.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 1/2/24.
//

import Foundation
import Combine

protocol GetCoinInfo {
    func callAsFunction(coinID: String) -> AnyPublisher<CoinInfo?, Never>
}
