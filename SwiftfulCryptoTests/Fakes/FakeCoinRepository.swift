//
//  FakeCoinRepository.swift
//  SwiftfulCryptoTests
//
//  Created by Kwabena Berko on 1/5/24.
//

import Combine
@testable import SwiftfulCrypto

class FakeCoinRepository: CoinRepository {
    
    private let coinsPublisher = CurrentValueSubject<[String: Coin], Never>([:])
    private let coinInfoPublisher = CurrentValueSubject<CoinInfo?, Never>(nil)
    private let syncStatusPublisher = CurrentValueSubject<SyncStatus, Never>(SyncStatus.none)
    private var initialSyncPublisher = CurrentValueSubject<Bool, Never>(false)
    private var syncResult: Bool = false
    
    var syncStatus: AnyPublisher<SyncStatus, Never> {
        return syncStatusPublisher
            .eraseToAnyPublisher()
    }
    
    var hasCompletedInitialSync: AnyPublisher<Bool, Never> {
        return initialSyncPublisher
            .eraseToAnyPublisher()
    }
    
    var coins: AnyPublisher<[Coin], Never> {
        return coinsPublisher
            .map { dict in
                return Array(dict.values)
            }
            .eraseToAnyPublisher()
    }
    
    func getCoin(coinID: String) -> AnyPublisher<Coin?, Never> {
        return coinsPublisher
            .map { dict in
                return dict[coinID]
            }
            .eraseToAnyPublisher()
    }
    
    func getCoinInfo(coinID: String) -> AnyPublisher<CoinInfo?, Never> {
        return coinInfoPublisher
            .eraseToAnyPublisher()
    }
    
    func sync() async -> Bool {
        return syncResult
    }
    
    func setCoins(items: [Coin]) {
        coinsPublisher.value = items
            .reduce(into: [String: Coin]()){ dict, item in
                dict[item.id] = item
            }
        
    }
    
    func setCoinInfo(coinInfo: CoinInfo?) {
        coinInfoPublisher.value = coinInfo
    }
    
}
