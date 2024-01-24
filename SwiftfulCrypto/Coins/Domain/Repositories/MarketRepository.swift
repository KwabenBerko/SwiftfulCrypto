//
//  MarketRepository.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 1/2/24.
//

import Foundation
import Combine

protocol MarketRepository: SyncableRepository {
    var marketInfo: AnyPublisher<MarketInfo?, Never> { get }
}
