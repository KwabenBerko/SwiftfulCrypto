//
//  RealGetCoinDetail.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 1/2/24.
//

import Foundation
import Combine

class RealGetCoinInfo: GetCoinInfo {
    
    private let repository: CoinRepository
    
    init(repository: CoinRepository) {
        self.repository = repository
    }
    
    func callAsFunction(coinID: String) -> AnyPublisher<CoinInfo?, Never> {
        return repository.getCoinInfo(coinID: coinID)
    }
}
