//
//  RealGetMarketInfoTests.swift
//  SwiftfulCryptoTests
//
//  Created by Kwabena Berko on 1/8/24.
//

import XCTest
@testable import SwiftfulCrypto

final class RealGetMarketInfoTests: XCTestCase {
    private var repository: FakeMarketRepository!
    private var sut: RealGetMarketInfo!
    
    override func setUp() async throws {
        repository = FakeMarketRepository()
        sut = RealGetMarketInfo(repository: repository)
    }
    
    func test_ShouldReturnMarketInfo() throws {
        let expected = MarketInfoFactory.makeMarketInfo()
        repository.setMarketInfo(marketInfo: expected)
        let subscriber = TestSubscriber(sut.callAsFunction())
                
        XCTAssertEqual([expected], subscriber.values)
    }
}
