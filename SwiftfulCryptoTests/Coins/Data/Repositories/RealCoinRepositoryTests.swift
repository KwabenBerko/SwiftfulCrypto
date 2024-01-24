//
//  RealCoinRepositoryTests.swift
//  SwiftfulCryptoTests
//
//  Created by Kwabena Berko on 1/4/24.
//

import XCTest
import Combine
import CoreData
import Alamofire
import Mocker
@testable import SwiftfulCrypto



final class RealCoinRepositoryTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()
    private var defaults: UserDefaults!
    private var session: Session!
    private var context: NSManagedObjectContext!
    private var dateProvider: DateProvider!
    private var sut: RealCoinRepository!
    private let fixedDate = Date()
    
    private let coin = CoinFactory.makeCoin()
    private let coinInfo = CoinInfoFactory.makeCoinInfo()
    
    override func setUp() async throws {
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        
        let database = SwiftfulCryptoDatabase(inMemory: true)
        
        context = database.container.viewContext
        defaults = UserDefaults.inMemory
        session = Session.inMemory
        dateProvider = FakeDateProvider(fixedDate)
                
        sut = RealCoinRepository(
            context: context,
            defaults: defaults,
            session: session,
            mapToEntity: { _, _ in
                return CoinFactory.makeCoinEntity(context: self.context)
            },
            mapToCoin: { _ in
                return self.coin
            },
            mapToCoinInfo: { _ in
                return self.coinInfo
            },
            dateProvider: dateProvider
        )
    }
    
    func test_ShouldReturnEmptyCoins_IfNoneExists() throws {
        let expected = [Coin]()
        let subscriber = TestSubscriber(sut.coins)
        
        XCTAssertEqual([expected], subscriber.values)
    }
    
    func test_ShouldReturnCoins_IfAnyExists() throws {
        let _ = [CoinFactory.makeCoinEntity(context: context)]
        let expected = [self.coin]
        let subscriber = TestSubscriber(sut.coins)
        
        XCTAssertEqual([expected], subscriber.values)
        
    }
    
    func test_ShouldNotReturnCoin_IfItDoesNotExist() throws {
        let coinID = "bitcoin"
        let subscriber = TestSubscriber(sut.getCoin(coinID: coinID))
        
        XCTAssertEqual([nil], subscriber.values)
    }
    
    func test_ShouldReturnCoin_IfItExists() throws {
        let coinID = "bitcoin"
        let _ = CoinFactory.makeCoinEntity(context: context, coinID: coinID)
        let expected = self.coin
        let subscriber = TestSubscriber(sut.getCoin(coinID: coinID))
        
        XCTAssertEqual([expected], subscriber.values)
    }
    
    func test_ShouldReturnFalse_IfHasNotCompletedInitialSync() throws {
        let subscriber = TestSubscriber(sut.hasCompletedInitialSync)
                
        XCTAssertEqual([false], subscriber.values)
    }
    
    func test_ShouldReturnTrue_IfHasCompletedInitialSync() throws {
        defaults.coinsLastRefreshed = fixedDate
        let subscriber = TestSubscriber(sut.hasCompletedInitialSync)
                
        XCTAssertEqual([true], subscriber.values)
        
    }
    
    func test_ShouldNotReturnCoinInfo_IfRetrievalFails() throws {
        var values: [CoinInfo?] = []
        let coinID = "bitcoin"
        let mock = Mock(
            url: URL(string: APIEndpoint.coinInfo(coinID: coinID))!,
            dataType: .json,
            statusCode: 500,
            data: [.get: Data.empty]
        )
        mock.register()
        let expectation = expectation(description: "CoinDetails")
        
        sut.getCoinInfo(coinID: coinID)
            .sink { _ in
                expectation.fulfill()
            } receiveValue: {
                values.append($0)
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 1.0)
        XCTAssertEqual([nil], values)
        
    }
    
    func test_ShouldReturnCoinInfo_IfRetrievalIsSuccessful() throws {
        var values: [CoinInfo?] = []
        let url = bundle(forResource:"coin_details_success", withExtension: "json")
        let expected = self.coinInfo
        let mock = Mock(
            url: URL(string: APIEndpoint.coinInfo(coinID: expected.id))!,
            dataType: .json,
            statusCode: 200,
            data: [.get : try Data(contentsOf: url)]
        )
        mock.register()
        let expectation = expectation(description: "CoinDetails")
        
        sut.getCoinInfo(coinID: expected.id)
            .sink { _ in
                expectation.fulfill()
            } receiveValue: {
                values.append($0)
            }
            .store(in: &cancellables)
                
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual([expected], values)
    }
    
    func test_ShouldReturnFalse_IfSyncFails() async  throws {
        let mock = Mock(
            url: URL(string: APIEndpoint.coins())!,
            dataType: .json,
            statusCode: 500,
            data: [.get: Data.empty]
        )
        mock.register()
        let syncStatusSubscriber = TestSubscriber(sut.syncStatus)
        let coinsSubscriber = TestSubscriber(sut.coins)
        
        let actual = await sut.sync()
        XCTAssertNil(defaults.coinsLastRefreshed)
        XCTAssertEqual([SyncStatus.none, SyncStatus.inProgress, SyncStatus.failed], syncStatusSubscriber.values)
        XCTAssertEqual([[]], coinsSubscriber.values)
        XCTAssertFalse(actual)
    }
    
    func test_ShouldReturnTrue_IfSyncSucceeds() async  throws {
        let url = bundle(forResource: "coins_success", withExtension: "json")
        let mock = Mock(
            url: URL(string: APIEndpoint.coins())!,
            dataType: .json,
            statusCode: 200,
            data: [.get: try Data(contentsOf: url)]
        )
        mock.register()
        let syncStatusSubscriber = TestSubscriber(sut.syncStatus)
        let coinsSubscriber = TestSubscriber(sut.coins)
        
        let actual = await sut.sync()
        XCTAssertEqual(self.fixedDate, defaults.coinsLastRefreshed)
        XCTAssertEqual([SyncStatus.none, SyncStatus.inProgress, SyncStatus.success], syncStatusSubscriber.values)
        XCTAssertEqual([[], [coin]], coinsSubscriber.values)
        XCTAssertTrue(actual)
    }
}
