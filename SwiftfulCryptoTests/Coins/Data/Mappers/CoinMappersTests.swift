//
//  CoinMappersTest.swift
//  SwiftfulCryptoTests
//
//  Created by Kwabena Berko on 1/8/24.
//

import XCTest
import CoreData
@testable import SwiftfulCrypto

final class CoinMappersTests: XCTestCase {
    private var context: NSManagedObjectContext!
    private let sut = CoinMappers.self
    
    override func setUp() async throws {
        let database = SwiftfulCryptoDatabase(inMemory: true)
        context = database.container.viewContext
    }
    
    func test_mapToEntity_ShouldReturnNil_IfNetworkIsNil() throws {
        let actual = sut.mapToEntity(context: context, nil)
        
        XCTAssertNil(actual)
    }
    
    func test_mapToEntity_ShouldReturnEntity_IfNetworkIsNotNil() throws {
        let network = CoinFactory.makeNetworkCoin(
            id: "bitcoin",
            symbol: "btc",
            name: "Bitcoin",
            image: "http://google.com",
            currentPrice: 1.1,
            marketCap: 1.2,
            marketCapRank: 1,
            fullyDilutedValuation: 1.3,
            totalVolume: 1.4,
            high24H: 1.5,
            low24H: 1.6,
            priceChange24H: 1.7,
            priceChangePercentage24H: 1.8,
            marketCapChange24H: 1.9,
            marketCapChangePercentage24H: 2.0,
            circulatingSupply: 2.1,
            totalSupply: 2.2,
            maxSupply: 2.3,
            ath: 2.4,
            athChangePercentage: 2.5,
            athDate: "2021-04-14T11:54:46.763Z",
            atl: 2.6,
            atlChangePercentage: 2.7,
            atlDate: "2013-07-06T00:00:00.000Z",
            lastUpdated: "2021-05-09T04:06:09.766Z",
            sparklineIn7D: NetworkSparklineIn7D(price: [2.8,2.9]),
            priceChangePercentage24HInCurrency: 3.0
        )
        
        let actual = sut.mapToEntity(context: context, network)
        
        XCTAssertEqual("bitcoin", actual?.coinID)
        XCTAssertEqual("btc", actual?.symbol)
        XCTAssertEqual("Bitcoin", actual?.name)
        XCTAssertEqual("http://google.com", actual?.imageURL)
        XCTAssertEqual(1.1, actual?.currentPrice)
        XCTAssertEqual(1.2, actual?.marketCap)
        XCTAssertEqual(1, actual?.marketCapRank)
        XCTAssertEqual(1.3, actual?.fullyDilutedValuation)
        XCTAssertEqual(1.4, actual?.totalVolume)
        XCTAssertEqual(1.5, actual?.high24H)
        XCTAssertEqual(1.6, actual?.low24H)
        XCTAssertEqual(1.7, actual?.priceChange24H)
        XCTAssertEqual(1.8, actual?.priceChangePercentage24H)
        XCTAssertEqual(1.9, actual?.marketCapChange24H)
        XCTAssertEqual(2.0, actual?.marketCapChangePercentage24H)
        XCTAssertEqual(2.1, actual?.circulatingSupply)
        XCTAssertEqual(2.2, actual?.totalSupply)
        XCTAssertEqual(2.3, actual?.maxSupply)
        XCTAssertEqual(2.4, actual?.ath)
        XCTAssertEqual(2.5, actual?.athChangePercentage)
        XCTAssertEqual("2021-04-14T11:54:46.763Z", actual?.athDate)
        XCTAssertEqual(2.6, actual?.atl)
        XCTAssertEqual(2.7, actual?.atlChangePercentage)
        XCTAssertEqual("2013-07-06T00:00:00.000Z", actual?.atlDate)
        XCTAssertEqual("2021-05-09T04:06:09.766Z", actual?.lastUpdated)
        XCTAssertEqual("[2.8,2.9]", actual?.sparklineIn7D)
        XCTAssertEqual(3.0, actual?.priceChangePercentage24HInCurrency)
        XCTAssertEqual(0, actual?.currentHoldings)
    }
    
    func test_mapToEntity_ShouldReturnDefaultValues_ForNilFields() throws {
        let network = CoinFactory.makeNetworkCoin(
            marketCap: nil,
            marketCapRank: nil,
            fullyDilutedValuation: nil,
            totalVolume: nil,
            high24H: nil,
            low24H: nil,
            priceChange24H: nil,
            priceChangePercentage24H: nil,
            marketCapChange24H: nil,
            marketCapChangePercentage24H: nil,
            circulatingSupply: nil,
            totalSupply: nil,
            maxSupply: nil,
            ath: nil,
            athChangePercentage: nil,
            athDate: nil,
            atl: nil,
            atlChangePercentage: nil,
            atlDate: nil,
            lastUpdated: nil,
            sparklineIn7D: nil,
            priceChangePercentage24HInCurrency: nil
        )
        
        let actual = sut.mapToEntity(context: context, network)
        
        XCTAssertEqual(0, actual?.marketCap)
        XCTAssertEqual(0, actual?.marketCapRank)
        XCTAssertEqual(0, actual?.fullyDilutedValuation)
        XCTAssertEqual(0, actual?.totalVolume)
        XCTAssertEqual(0, actual?.high24H)
        XCTAssertEqual(0, actual?.low24H)
        XCTAssertEqual(0, actual?.priceChange24H)
        XCTAssertEqual(0, actual?.priceChangePercentage24H)
        XCTAssertEqual(0, actual?.marketCapChange24H)
        XCTAssertEqual(0, actual?.marketCapChangePercentage24H)
        XCTAssertEqual(0, actual?.circulatingSupply)
        XCTAssertEqual(0, actual?.totalSupply)
        XCTAssertEqual(0, actual?.maxSupply)
        XCTAssertEqual(0, actual?.ath)
        XCTAssertEqual(0, actual?.athChangePercentage)
        XCTAssertEqual(nil, actual?.athDate)
        XCTAssertEqual(0, actual?.atl)
        XCTAssertEqual(0, actual?.atlChangePercentage)
        XCTAssertEqual(nil, actual?.atlDate)
        XCTAssertEqual(nil, actual?.lastUpdated)
        XCTAssertEqual(nil, actual?.sparklineIn7D)
        XCTAssertEqual(0, actual?.priceChangePercentage24HInCurrency)
        XCTAssertEqual(0, actual?.currentHoldings)
    }
    
    func test_mapToCoin_ShouldReturnNil_IfEntityIsNil() throws {
        let actual = sut.mapToCoin(input: nil)
        
        XCTAssertNil(actual)
    }
    
    func test_mapToCoin_ShouldReturnNil_IfCoinIDIsNil() throws {
        let entity = CoinFactory.makeCoinEntity(context: context, coinID: nil)
        
        let actual = sut.mapToCoin(input: entity)
        
        XCTAssertNil(actual)
    }
    
    func test_mapToCoin_ShouldReturnNil_IfNameIsNil() throws {
        let entity = CoinFactory.makeCoinEntity(context: context, name: nil)
        
        let actual = sut.mapToCoin(input: entity)
        
        XCTAssertNil(actual)
    }
    
    func test_mapToCoin_ShouldReturnNil_IfSymbolIsNil() throws {
        let entity = CoinFactory.makeCoinEntity(context: context, symbol: nil)
        
        let actual = sut.mapToCoin(input: entity)
        
        XCTAssertNil(actual)
    }
    
    func test_mapToCoin_ShouldReturnDefaultValues_ForNilFields() throws {
        let entity = CoinFactory.makeCoinEntity(
            context: context,
            athDate: nil,
            atlDate: nil,
            high24H: 0,
            low24H: 0,
            imageURL: nil,
            lastUpdated: nil,
            priceChange24H: 0,
            sparklineIn7D: nil
        )
        
        let actual = sut.mapToCoin(input: entity)
        
        
        XCTAssertEqual(nil, actual?.athDate)
        XCTAssertEqual(nil, actual?.atlDate)
        XCTAssertEqual(nil, actual?.high24H)
        XCTAssertEqual(nil, actual?.low24H)
        XCTAssertEqual("", actual?.image)
        XCTAssertEqual(nil, actual?.atlDate)
        XCTAssertEqual(nil, actual?.priceChange24H)
        XCTAssertEqual(SparklineIn7D(prices: []), actual?.sparklineIn7D)
    }
    
    func test_mapToCoin_ShouldReturnCoin_IfEntityIsNotNil() throws {
        let entity = CoinFactory.makeCoinEntity(
            context: context,
            coinID: "bitcoin",
            name: "Bitcoin",
            symbol: "btc",
            ath: 1.1,
            athChangePercentage: 1.2,
            athDate: "2021-05-09T04:06:09.766Z",
            atl: 1.3,
            atlChangePercentage: 1.4,
            atlDate: "2021-05-09T04:06:09.766Z",
            circulatingSupply: 1.5,
            currentHoldings: 1.6,
            currentPrice: 1.7,
            fullyDilutedValuation: 1.8,
            high24H: 1.9,
            low24H: 2.0,
            imageURL: "http://google.com",
            lastUpdated: "2021-05-09T04:06:09.766Z",
            marketCap: 2.1,
            marketCapChange24H: 2.2,
            marketCapChangePercentage24H: 2.3,
            marketCapRank: 1,
            maxSupply: 2.4,
            priceChange24H: 2.5,
            priceChangePercentage24H: 2.6,
            priceChangePercentage24HInCurrency: 2.7,
            sparklineIn7D: "[2.8,2.9]",
            totalSupply: 3.0,
            totalVolume: 3.1
        )
        
        let actual = sut.mapToCoin(input: entity)
        
        XCTAssertEqual("bitcoin", actual?.id)
        XCTAssertEqual("Bitcoin", actual?.name)
        XCTAssertEqual("btc", actual?.symbol)
        XCTAssertEqual(1.1, actual?.ath)
        XCTAssertEqual(1.2, actual?.athChangePercentage)
        XCTAssertEqual(Date(timeIntervalSince1970: 1620533169.766), actual?.athDate)
        XCTAssertEqual(1.3, actual?.atl)
        XCTAssertEqual(1.4, actual?.atlChangePercentage)
        XCTAssertEqual(1.2, actual?.athChangePercentage)
        XCTAssertEqual(Date(timeIntervalSince1970: 1620533169.766), actual?.atlDate)
        XCTAssertEqual(1.5, actual?.circulatingSupply)
        XCTAssertEqual(1.6, actual?.currentHoldings)
        XCTAssertEqual(1.7, actual?.currentPrice)
        XCTAssertEqual(1.8, actual?.fullyDilutedValuation)
        XCTAssertEqual(1.9, actual?.high24H)
        XCTAssertEqual(2.0, actual?.low24H)
        XCTAssertEqual("http://google.com", actual?.image)
        XCTAssertEqual(Date(timeIntervalSince1970: 1620533169.766), actual?.atlDate)
        XCTAssertEqual(2.1, actual?.marketCap)
        XCTAssertEqual(2.2, actual?.marketCapChange24H)
        XCTAssertEqual(2.3, actual?.marketCapChangePercentage24H)
        XCTAssertEqual(1, actual?.rank)
        XCTAssertEqual(2.4, actual?.maxSupply)
        XCTAssertEqual(2.5, actual?.priceChange24H)
        XCTAssertEqual(2.6, actual?.priceChangePercentage24H)
        XCTAssertEqual(2.7, actual?.priceChangePercentage24HInCurrency)
        XCTAssertEqual(SparklineIn7D(prices: [2.8,2.9]), actual?.sparklineIn7D)
        XCTAssertEqual(3.0, actual?.totalSupply)
        XCTAssertEqual(3.1, actual?.totalVolume)
    }
    
    func test_mapToCoinInfo_ShouldReturnNil_IfNetworkIsNil() throws {
        let actual = sut.mapToCoinInfo(input: nil)
        
        XCTAssertNil(actual)
    }
    
    func test_mapToCoinInfo_ShouldReturnDefaultValues_ForNilFields() {
        let network = CoinInfoFactory.makeNetworkCoinInfo(
            blockTimeInMinutes: nil,
            hashingAlgorithm: nil,
            description: nil,
            links: nil
        )
        
        let actual = sut.mapToCoinInfo(input: network)
        
        XCTAssertEqual(0, actual?.blockTimeInMinutes)
        XCTAssertEqual(nil, actual?.hashingAlgorithm)
        XCTAssertEqual(nil, actual?.description)
        XCTAssertEqual(nil, actual?.links)
    }
    
    func test_mapToCoinInfo_ShouldReturnCoinInfo_IfNetworkIsNotNil() {
        let network = CoinInfoFactory.makeNetworkCoinInfo(
            id: "bitcoin",
            blockTimeInMinutes: 10,
            hashingAlgorithm: "SHA-256",
            description: NetworkDescription(en: "A Description"),
            links: NetworkLinks(homepage: ["http://homepage.com"], subredditURL: "http://subreddit.com")
        )
        
        let actual = sut.mapToCoinInfo(input: network)
        
        XCTAssertEqual("bitcoin", actual?.id)
        XCTAssertEqual(10, actual?.blockTimeInMinutes)
        XCTAssertEqual("SHA-256", actual?.hashingAlgorithm)
        XCTAssertEqual(Description(en: "A Description"), actual?.description)
        XCTAssertEqual(Links(homepage: "http://homepage.com", subredditURL: "http://subreddit.com"), actual?.links)
    }
    
}
