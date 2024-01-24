//
//  RealMarketRepositoryTests.swift
//  SwiftfulCryptoTests
//
//  Created by Kwabena Berko on 1/4/24.
//

import XCTest
import CoreData
import Alamofire
import Mocker
@testable import SwiftfulCrypto

final class RealMarketRepositoryTests: XCTestCase {
    private var context: NSManagedObjectContext!
    private var defaults: UserDefaults!
    private var session: Session!
    private var mapToString: ((NetworkMarketInfoResponse?) -> String?)!
    private var mapToNetwork: ((String) -> NetworkMarketInfoResponse?)!
    private var mapToMarketInfo: ((NetworkMarketInfoResponse?) -> MarketInfo?)!
    private var dateProvider: DateProvider!
    private var sut: RealMarketRepository!
    private let fixedDate = Date()
    
    private let networkMarketInfo = MarketInfoFactory.makeNetworkMarketInfoResponse()
    private let marketInfo = MarketInfoFactory.makeMarketInfo()
    
    override func setUp() async throws {
        let database = SwiftfulCryptoDatabase(inMemory: true)
        
        context = database.container.viewContext
        defaults = UserDefaults.inMemory
        session = Session.inMemory
        mapToString = { _ in
            return ""
        }
        mapToNetwork = { _ in
            return self.networkMarketInfo
        }
        mapToMarketInfo = { _ in
            return self.marketInfo
        }
        dateProvider = FakeDateProvider(fixedDate)
        
        sut = RealMarketRepository(
            context: database.container.viewContext,
            defaults: defaults,
            session: session,
            mapToString: mapToString,
            mapToNetwork: mapToNetwork,
            mapToMarketInfo: mapToMarketInfo,
            dateProvider: dateProvider
        )
    }
    
    
    func test_ShouldNotReturnMarketInfo_IfNoneExists() throws {
        let subscriber = TestSubscriber(sut.marketInfo)
                
        XCTAssertEqual([nil], subscriber.values)
    }
    
    func test_ShouldReturnMarketInfo_IfItExists() throws {
        defaults.marketInfo = "empty"
        let expected = self.marketInfo
        let subscriber = TestSubscriber(sut.marketInfo)
        
        XCTAssertEqual([expected], subscriber.values)
    }
    
    func test_ShouldReturnFalse_IfHasNotCompletedInitialSync() throws {
        let subscriber = TestSubscriber(sut.hasCompletedInitialSync)
                
        XCTAssertEqual([false], subscriber.values)
    }
    
    func test_ShouldReturnTrue_IfHasCompletedInitialSync() throws {
        defaults.marketInfoLastRefreshed = fixedDate
        let subscriber = TestSubscriber(sut.hasCompletedInitialSync)

        XCTAssertEqual([true], subscriber.values)
    }
    
    func test_ShouldReturnFalse_IfSyncFails() async throws {
        let mock = Mock(
            url: URL(string: APIEndpoint.marketInfo())!,
            dataType: .json,
            statusCode: 500,
            data: [.get: Data.empty]
        )
        mock.register()
        let syncStatusSubscriber = TestSubscriber(sut.syncStatus)
        let marketInfoSubscriber = TestSubscriber(sut.marketInfo)
        
        let actual = await sut.sync()
        XCTAssertNil(defaults.marketInfoLastRefreshed)
        XCTAssertEqual([SyncStatus.none, SyncStatus.inProgress, SyncStatus.failed], syncStatusSubscriber.values)
        XCTAssertEqual([nil], marketInfoSubscriber.values)
        XCTAssertFalse(actual)
    }
    
    func test_ShouldReturnTrue_IfSyncSucceeds() async throws {
        let url = bundle(forResource: "market_info_success", withExtension: "json")
        let mock = Mock(
            url: URL(string: APIEndpoint.marketInfo())!,
            dataType: .json,
            statusCode: 200,
            data: [.get: try Data(contentsOf: url)]
        )
        mock.register()
        let syncStatusSubscriber = TestSubscriber(sut.syncStatus)
        let marketInfoSubscriber = TestSubscriber(sut.marketInfo)
        
        let actual = await sut.sync()
        XCTAssertEqual(fixedDate, defaults.marketInfoLastRefreshed)
        XCTAssertEqual([SyncStatus.none, SyncStatus.inProgress, SyncStatus.success], syncStatusSubscriber.values)
        XCTAssertEqual([nil, marketInfo], marketInfoSubscriber.values)
        XCTAssertTrue(actual)
    }
}
