//
//  RealPortfolioRepositoryTests.swift
//  SwiftfulCryptoTests
//
//  Created by Kwabena Berko on 1/5/24.
//

import XCTest
import CoreData
@testable import SwiftfulCrypto

final class RealPortfolioRepositoryTests: XCTestCase {
    private var context: NSManagedObjectContext!
    private var mapToPortfolio: ((PortfolioEntity?) -> Portfolio?)!
    private var sut: RealPortfolioRepository!
    
    private let portfolio = PortfolioFactory.makePortfolio()
    
    override func setUp() async throws {
        let database = SwiftfulCryptoDatabase(inMemory: true)
        
        context = database.container.viewContext
        mapToPortfolio = { _ in
            return self.portfolio
        }
        
        sut = RealPortfolioRepository(
            context: context,
            mapToPortfolio: mapToPortfolio
        )
    }
    
    
    func test_ShouldReturnEmptyPortfolio_IfNoneExists() throws {
        let expected = [Portfolio]()
        let subscriber = TestSubscriber(sut.portfolios)
        
        XCTAssertEqual([expected], subscriber.values)
    }
    
    func test_ShouldReturnPortfolios_IfAnyExists() throws {
        let _ = [PortfolioFactory.makePortfolioEntity(context: context)]
        let expected = [self.portfolio]
        
        let subscriber = TestSubscriber(sut.portfolios)
        
        XCTAssertEqual([expected], subscriber.values)
    }
    
    func test_ShouldReturnNoPortfolio_IfItDoesNotExist() async throws {
        let actual = await sut.getPortfolio(coinID: "btc")
        
        XCTAssertNil(actual)
    }
    
    func test_ShouldCreateNewPortfolio() async throws {
        let _ = PortfolioFactory.makePortfolioEntity(context: context)
        let expected = self.portfolio
        
        let actual = await sut.getPortfolio(coinID: expected.coinID)
        
        XCTAssertEqual(expected, actual)
    }
    
    func test_ShouldUpdateExistingPortfolio_IfItExists() async throws {
        let _ = PortfolioFactory.makePortfolioEntity(context: context)
        
        let created = await sut.getPortfolio(coinID: portfolio.coinID)!
        XCTAssertEqual(self.portfolio, created)
        let updated = created.updateAmount(amount: 100.0)
        await sut.updatePortfolio(coinID: updated.coinID, amount: updated.amount)
        
        
        let entity = try getPortfolioEntity(coinID: created.coinID)
        
        XCTAssertEqual(updated.coinID, entity?.coinID)
        XCTAssertEqual(updated.amount, entity?.amount)
        
    }
    
    func test_ShouldDeletePortfolio_IfItExists() async throws {
        let _ = PortfolioFactory.makePortfolioEntity(context: context)
        
        let created = await sut.getPortfolio(coinID: self.portfolio.coinID)!
        XCTAssertEqual(self.portfolio, created)
        await sut.deletePortfolio(coinID: created.coinID)
        
        let actual = await sut.getPortfolio(coinID: created.coinID)
        XCTAssertNil(actual)
    }
    
    private func getPortfolioEntity(coinID: String) throws -> PortfolioEntity? {
        let request = PortfolioEntity.fetchRequest()
        request.predicate = NSPredicate(format: "coinID == %@", coinID)
        
        return try context.fetch(request).first
    }
}
