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
    
//    func test_IsLoading() throws {
//        let recorder = sut.$isLoading.record()
//        
//        XCTAssertTrue(try wait(for: recorder.next()))
//        
//        getCoinDetail.setCoinDetail(coinDetail)
//        XCTAssertFalse(try wait(for: recorder.next()))
//    }
//    
//    func test_IsError() throws {
//        let recorder = sut.$isError.record()
//        
//        XCTAssertFalse(try wait(for: recorder.next()))
//        
//        getCoinDetail.setCoinDetail(nil)
//        XCTAssertTrue(try wait(for: recorder.next()))
//    }
//    
//    func test_ContentState() throws {
//        let overviewPublisher = sut.$overviewStatistics.record()
//        let additionalPublisher = sut.$additionalStatistics.record()
//        let descriptionPublisher = sut.$coinDescription.record()
//        let websiteURLPublisher = sut.$websiteURL.record()
//        let redditURLPublisher = sut.$redditURL.record()
//        let coinPublisher = sut.$coin.record()
//        
//        XCTAssertEqual([], try wait(for: overviewPublisher.next()))
//        XCTAssertEqual([], try wait(for: additionalPublisher.next()))
//        XCTAssertEqual(nil, try wait(for: descriptionPublisher.next()))
//        XCTAssertEqual(nil, try wait(for: websiteURLPublisher.next()))
//        XCTAssertEqual(nil, try wait(for: redditURLPublisher.next()))
//        XCTAssertEqual(coin, try wait(for: coinPublisher.next()))
//        
//        getCoinDetail.setCoinDetail(coinDetail)
//        
//        XCTAssertEqual([], try wait(for: overviewPublisher.next()))
//        XCTAssertEqual([], try wait(for: additionalPublisher.next()))
//        XCTAssertEqual(coinDetail.info.readableDescription, try wait(for: descriptionPublisher.next()))
//        XCTAssertEqual(coinDetail.info.links?.homepage, try wait(for: websiteURLPublisher.next()))
//        XCTAssertEqual(coinDetail.info.links?.subredditURL, try wait(for: redditURLPublisher.next()))
//        XCTAssertEqual(coin, try wait(for: coinPublisher.next()))
//    }
}
