//
//  FakePortfolioRepository.swift
//  SwiftfulCryptoTests
//
//  Created by Kwabena Berko on 1/2/24.
//

import Foundation
import Combine
@testable import SwiftfulCrypto

class FakePortfolioRepository: PortfolioRepository {
    
    private var portfoliosPublisher = CurrentValueSubject<[String: Portfolio], Never>([:])
    
    var portfolios: AnyPublisher<[Portfolio], Never> {
        return portfoliosPublisher
            .map { dict in
                return Array(dict.values)
            }
            .eraseToAnyPublisher()
    }
    
    func getPortfolio(coinID: String) async -> Portfolio? {
        return portfoliosPublisher.value[coinID]
    }
    
    func createPortfolio(coinID: String, amount: Double) async {
        let portfolio = Portfolio(coinID: coinID, amount: amount)
        portfoliosPublisher.value[coinID] = portfolio
    }
    
    func updatePortfolio(coinID: String, amount: Double) async {
        portfoliosPublisher.value[coinID] = Portfolio(coinID: coinID, amount: amount)
    }
    
    func deletePortfolio(coinID: String) async {
        portfoliosPublisher.value.removeValue(forKey: coinID)
    }
    
    func setPortfolios(items: [Portfolio]) {
        portfoliosPublisher.value = items
            .reduce(into: [String: Portfolio]()){ dict, item in
                dict[item.coinID] = item
            }
        
    }
}
