//
//  RealGetCoinsTests.swift
//  SwiftfulCryptoTests
//
//  Created by Kwabena Berko on 1/8/24.
//

import XCTest
@testable import SwiftfulCrypto

class RealGetCoinsTests: XCTestCase {
    private var sut: RealGetCoins!
    private var repository: FakeCoinRepository!
    
    override func setUp() async throws {
        repository = FakeCoinRepository()
        sut = RealGetCoins(repository: repository)
    }
    
    func test_ShouldReturnCoins() throws {
        let expected = [CoinFactory.makeCoin()]
        repository.setCoins(items: expected)
        let subscriber = TestSubscriber(sut.callAsFunction())
                
        XCTAssertEqual([expected], subscriber.values)
    }
}
