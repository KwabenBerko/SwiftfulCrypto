//
//  FakeGetCoinDetail.swift
//  SwiftfulCryptoTests
//
//  Created by Kwabena Berko on 1/6/24.
//
import Foundation

import Combine
@testable import SwiftfulCrypto

class FakeGetCoinDetail: GetCoinDetail {
    
    private let coinInfoPublisher = PassthroughSubject<CoinDetail?, Never>()
    
    func callAsFunction(coinID: String) -> AnyPublisher<CoinDetail?, Never> {
        return coinInfoPublisher
            .eraseToAnyPublisher()
    }
    
    func setCoinDetail(_ coinInfo: CoinDetail?) {
        coinInfoPublisher.send(coinInfo)
    }
}
