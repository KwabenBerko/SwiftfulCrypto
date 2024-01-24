//
//  RealGetMarketInfo.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 1/2/24.
//

import Foundation
import Combine

class RealGetMarketInfo: GetMarketInfo {
    private let repository: MarketRepository
    
    init(repository: MarketRepository) {
        self.repository = repository
    }
    
    func callAsFunction() -> AnyPublisher<MarketInfo?, Never> {
        repository.marketInfo
    }
}
