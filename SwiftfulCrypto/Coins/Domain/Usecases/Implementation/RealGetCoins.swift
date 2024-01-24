//
//  RealGetCoins.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 1/1/24.
//

import Foundation
import Combine

class RealGetCoins: GetCoins {
    
    private let repository: CoinRepository
    
    init(repository: CoinRepository) {
        self.repository = repository
    }
    
    func callAsFunction() -> AnyPublisher<[Coin], Never> {
        return repository.coins
    }
}
