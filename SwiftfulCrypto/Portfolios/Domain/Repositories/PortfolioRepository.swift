//
//  PorfolioRepository.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 1/1/24.
//

import Foundation
import Combine

protocol PortfolioRepository {
    var portfolios: AnyPublisher<[Portfolio], Never> { get }
    func getPortfolio(coinID: String) async -> Portfolio?
    func createPortfolio(coinID: String, amount: Double) async
    func updatePortfolio(coinID: String, amount: Double) async
    func deletePortfolio(coinID: String) async
}
