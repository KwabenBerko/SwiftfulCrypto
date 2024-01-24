//
//  CoinRepository.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 1/2/24.
//

import Foundation
import Combine

protocol CoinRepository: SyncableRepository {
    var coins: AnyPublisher<[Coin], Never> { get }
    func getCoin(coinID: String) -> AnyPublisher<Coin?, Never>
    func getCoinInfo(coinID: String) -> AnyPublisher<CoinInfo?, Never>
}
