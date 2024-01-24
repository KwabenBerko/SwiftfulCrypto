//
//  RealGetCoinInfoTests.swift
//  SwiftfulCryptoTests
//
//  Created by Kwabena Berko on 1/8/24.
//

import XCTest
@testable import SwiftfulCrypto

final class RealGetCoinInfoTests: XCTestCase {
    private var repository: FakeCoinRepository!
    private var sut: RealGetCoinInfo!

    override func setUp() async throws {
        repository = FakeCoinRepository()
        sut = RealGetCoinInfo(repository: repository)
    }
    
    func test_ShouldReturnCoinInfo() throws {
        let expected = CoinInfoFactory.makeCoinInfo()
        repository.setCoinInfo(coinInfo: expected)
        let subscriber = TestSubscriber(sut.callAsFunction(coinID: "coinID"))
        
        XCTAssertEqual([expected], subscriber.values)
    }
}
