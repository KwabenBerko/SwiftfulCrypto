//
//  RealManagePortfolioTest.swift
//  SwiftfulCryptoTests
//
//  Created by Kwabena Berko on 1/2/24.
//

import XCTest
import Combine
@testable import SwiftfulCrypto

final class RealManagePortfolioTest: XCTestCase {
    
    private var repository: FakePortfolioRepository!
    private var sut: RealManagePortfolio!
    
    override func setUp() async throws {
        repository = FakePortfolioRepository()
        sut = RealManagePortfolio(repository: repository)
    }

    func test_shouldCreateNewPortfolioEntry_WhenNoneExists() async throws {
        let portfolio = PortfolioFactory.makePortfolio()
        let expected = [portfolio]
        let subscriber = TestSubscriber(repository.portfolios)
        
        await sut.callAsFunction(coinID: portfolio.coinID, amount: portfolio.amount)
        XCTAssertEqual([[], expected], subscriber.values)
    }
    
    func test_ShouldUpdatePortfolioEntry_WhenAlreadyExists() async throws {
        let portfolio = PortfolioFactory.makePortfolio()
        let initial = [portfolio]
        let updated = portfolio.updateAmount(amount: 100.0)
        let expected = [updated]
        repository.setPortfolios(items: [portfolio])
        let subscriber = TestSubscriber(repository.portfolios)
        
        await sut.callAsFunction(coinID: updated.coinID, amount: updated.amount)
        XCTAssertEqual([initial, expected], subscriber.values)
    }
    
    func test_shouldDeletePortfolioEntry_WhenAlreadyExistsAndAmountIsZero() async throws {
        let portfolio = PortfolioFactory.makePortfolio()
        let initial = [portfolio]
        let expected: [Portfolio] = []
        repository.setPortfolios(items: [portfolio])
        let subscriber = TestSubscriber(repository.portfolios)
        
        await sut.callAsFunction(coinID: portfolio.coinID, amount: 0.0)
        XCTAssertEqual([initial, expected], subscriber.values)
    }
}
