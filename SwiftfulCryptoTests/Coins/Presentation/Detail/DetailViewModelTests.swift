//
//  DetailViewModelTests.swift
//  SwiftfulCryptoTests
//
//  Created by Kwabena Berko on 1/6/24.
//

import XCTest
import Combine
@testable import SwiftfulCrypto


final class DetailViewModelTests: XCTestCase {
    
    private let coin = CoinFactory.makeCoin()
    private let overview = StatisticFactory.makeStatistic()
    private let additional = StatisticFactory.makeStatistic()
    private var coinDetail: CoinDetail!
    private var getCoinDetail: FakeGetCoinDetail!
    
    override func setUp() async throws {
        let statistics = Statistics(overview: [overview], additional: [additional])
        coinDetail = CoinDetailFactory.makeCoinDetail(statistics: statistics)
        getCoinDetail = FakeGetCoinDetail()
    }
    
    lazy var sut: DetailViewModel = {
        DetailViewModel(
            coin: coin,
            getCoinDetail: getCoinDetail,
            scheduler: .immediate
        )
    }()
    
    func test_LoadingState() throws {
        let subscriber = TestSubscriber(sut.$isLoading.eraseToAnyPublisher())
        
        XCTAssertEqual([true], subscriber.values)
        
        getCoinDetail.setCoinDetail(nil)
        XCTAssertEqual([true, false], subscriber.values)
    }
}
