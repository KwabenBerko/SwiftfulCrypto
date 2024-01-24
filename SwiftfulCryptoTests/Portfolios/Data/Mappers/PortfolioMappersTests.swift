//
//  PortfolioMappersTests.swift
//  SwiftfulCryptoTests
//
//  Created by Kwabena Berko on 1/8/24.
//

import XCTest
import CoreData
@testable import SwiftfulCrypto

final class PortfolioMappersTests: XCTestCase {
    private var context: NSManagedObjectContext!
    private let sut = PortfolioMappers.self
    
    override func setUp() async throws {
        let database = SwiftfulCryptoDatabase(inMemory: true)
        context = database.container.viewContext
    }
    
    func test_mapToPortfolio_ShouldReturnNil_IfEntityIsNil() throws {
        let actual = sut.mapToPortfolio(nil)
        
        XCTAssertNil(actual)
    }
    
    func test_mapToPortfolio_ShouldReturnPortfolio() throws {
        let entity = PortfolioFactory.makePortfolioEntity(
            context: context,
            coinID: "bitcoin",
            amount: 500.0
        )
        
        let actual = sut.mapToPortfolio(entity)
        
        XCTAssertEqual("bitcoin", actual?.coinID)
        XCTAssertEqual(500.0, actual?.amount)
    }
    
}
