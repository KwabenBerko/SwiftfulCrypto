//
//  GetCoins.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 1/1/24.
//

import Foundation
import Combine

protocol GetCoins {
    func callAsFunction() -> AnyPublisher<[Coin], Never>
}
