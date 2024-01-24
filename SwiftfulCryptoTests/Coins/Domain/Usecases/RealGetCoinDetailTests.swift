//
//  RealGetCoinDetailTest.swift
//  SwiftfulCryptoTests
//
//  Created by Kwabena Berko on 1/6/24.
//

import XCTest
@testable import SwiftfulCrypto

final class RealGetCoinDetailTests: XCTestCase {
    
    private var repository: FakeCoinRepository!
    private var sut: RealGetCoinDetail!
    
    override func setUp() async throws {
        repository = FakeCoinRepository()
        sut = RealGetCoinDetail(repository: repository)
    }
    
    func test_ShouldNotReturnDetail_IfItCoinDoesNotExist() throws {
        let coinID = "bitcoin"
        repository.setCoinInfo(coinInfo: CoinInfoFactory.makeCoinInfo())
        let subscriber = TestSubscriber(sut.callAsFunction(coinID: coinID))
        
        XCTAssertEqual([nil], subscriber.values)
    }
    
    func test_ShouldNotReturnDetail_IfItCoinDetailDoesNotExist() throws {
        let coinID = "bitcoin"
        repository.setCoins(items: [CoinFactory.makeCoin()])
        let subscriber = TestSubscriber(sut.callAsFunction(coinID: coinID))
                
        XCTAssertEqual([nil], subscriber.values)
    }
    
    func test_ShouldReturnCoinDetail_IfItExists() throws {
        let coin = CoinFactory.makeCoin()
        let info = CoinInfoFactory.makeCoinInfo()
        let expected = CoinDetail(
            coin: coin,
            info: info,
            statistics: makeStatistics()
        )
        repository.setCoins(items: [coin])
        repository.setCoinInfo(coinInfo: info)
        let subscriber = TestSubscriber(sut.callAsFunction(coinID: coin.id))
                
        XCTAssertEqual([expected], subscriber.values)
    }
    
    private func makeStatistics() -> Statistics {
        let currentPrice = StatisticFactory.makeStatistic(
            title: .currentPrice,
            value: .amount(58908.0),
            percentageChange: 1.39234
        )
        let marketCap = StatisticFactory.makeStatistic(
            title: .marketCapitilization,
            value: .amount(1100013258170.0),
            percentageChange: 1.21837
        )
        let rank = StatisticFactory.makeStatistic(
            title: .rank,
            value: .text("1")
        )
        let volume = StatisticFactory.makeStatistic(
            title: .volume,
            value: .amount(69075964521.0),
            percentageChange: nil
        )
        
        let high24 = StatisticFactory.makeStatistic(
            title: .high24,
            value: .amount(59504.0)
        )
        let low24 = StatisticFactory.makeStatistic(
            title: .low24,
            value: .amount(57672.0)
        )
        let priceChange24 = StatisticFactory.makeStatistic(
            title: .priceChange24H,
            value: .amount(808.94),
            percentageChange: 1.39234
        )
        let marketCapChange24 = StatisticFactory.makeStatistic(
            title: .marketCapChange24H,
            value: .amount(13240944103.0),
            percentageChange: 1.21837
        )
        let blockTime = StatisticFactory.makeStatistic(
            title: .blockTime,
            value: .text("10")
        )
        let hashingAlgorithm = StatisticFactory.makeStatistic(
            title: .hashingAlgorithm,
            value: .text("SHA-256")
        )
        
        let overview = [currentPrice, marketCap, rank, volume]
        let additional = [high24, low24, priceChange24, marketCapChange24, blockTime, hashingAlgorithm]
        return Statistics(overview: overview, additional: additional)
    }
}

