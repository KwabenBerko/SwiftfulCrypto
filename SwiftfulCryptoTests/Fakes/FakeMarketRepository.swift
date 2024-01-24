//
//  FakeMarketRepository.swift
//  SwiftfulCryptoTests
//
//  Created by Kwabena Berko on 1/8/24.
//

import Combine
@testable import SwiftfulCrypto

class FakeMarketRepository: MarketRepository {
    private var marketInfoPublisher = CurrentValueSubject<MarketInfo?, Never>(nil)
    private var syncStatusPublisher = CurrentValueSubject<SyncStatus, Never>(SyncStatus.none)
    private var hasCompletedInitialSyncPublisher = CurrentValueSubject<Bool, Never>(false)
    private var syncResult: Bool = false
    
    var marketInfo: AnyPublisher<SwiftfulCrypto.MarketInfo?, Never> {
        return marketInfoPublisher
            .eraseToAnyPublisher()
    }
    
    var syncStatus: AnyPublisher<SwiftfulCrypto.SyncStatus, Never> {
        return syncStatusPublisher
            .eraseToAnyPublisher()
    }
    
    var hasCompletedInitialSync: AnyPublisher<Bool, Never> {
        return hasCompletedInitialSyncPublisher
            .eraseToAnyPublisher()
    }
    
    func sync() async -> Bool {
        return syncResult
    }
    
    func setMarketInfo(marketInfo: MarketInfo) {
        marketInfoPublisher.value = marketInfo
    }
}
