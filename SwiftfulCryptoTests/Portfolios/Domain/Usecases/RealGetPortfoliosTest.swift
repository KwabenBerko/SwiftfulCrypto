//
//  RealGetPortfolioTest.swift
//  SwiftfulCryptoTests
//
//  Created by Kwabena Berko on 1/5/24.
//

import XCTest
@testable import SwiftfulCrypto

final class RealGetPortfoliosTest: XCTestCase {
    private var portfolioRespository: FakePortfolioRepository!
    private var coinRepository: FakeCoinRepository!
    private var sut: RealGetPortfolios!
    
    override func setUp() async throws {
        portfolioRespository = FakePortfolioRepository()
        coinRepository = FakeCoinRepository()
        sut = RealGetPortfolios(
            portfolioRepository: portfolioRespository,
            coinRepository: coinRepository
        )
    }
    
    func test_ShouldReturnEmptyCoins_IfNoPortfolios() throws {
        portfolioRespository.setPortfolios(items: [])
        coinRepository.setCoins(items: [CoinFactory.makeCoin()])
        let expected = [Coin]()
        let subscriber = TestSubscriber(sut.callAsFunction())
        
        XCTAssertEqual([expected], subscriber.values)
    }
    
    func test_ShouldReturnCoinsForPortfolios() throws {
        let btc = CoinFactory.makeCoin(id: "bitcoin")
        let eth = CoinFactory.makeCoin(id: "ethereum")
        let portfolio = PortfolioFactory.makePortfolio(coinID: btc.id, amount: 200.0)
        portfolioRespository.setPortfolios(items: [portfolio])
        coinRepository.setCoins(items: [btc, eth])
        let expected = [btc.updateHoldings(amount: portfolio.amount)]
        let subscriber = TestSubscriber(sut.callAsFunction())
                
        XCTAssertEqual([expected], subscriber.values)
    }
}
