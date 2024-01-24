//
//  MarketInfoMappersTest.swift
//  SwiftfulCryptoTests
//
//  Created by Kwabena Berko on 1/7/24.
//

import XCTest
@testable import SwiftfulCrypto

final class MarketInfoMappersTests: XCTestCase {
    
    private let sut = MarketInfoMappers.self
    
    func test_mapToString_ShouldReturnNil_IfNetworkResponseIsNil() throws {
        let actual = sut.mapToString(nil)
        
        XCTAssertNil(actual)
        
    }
    
    func test_mapToString_ShouldReturnString_IfNetworkResponseIsNotNil() throws {
        let response = makeNetworkMarketInfoResponse()
                
        let actual = sut.mapToString(response)
        
        XCTAssertNotNil(actual)
        
    }
    
    func test_mapToNetwork_ShouldReturnNil_IfStringIsEmpty() throws {
        let actual = sut.mapToNetwork("")
        
        XCTAssertNil(actual)
    }
    

    func test_mapToNetwork_ShouldReturnNetworkResponse_IfStringIsNotEmpty() throws {
        let actual = sut.mapToNetwork(json)
        
        XCTAssertNotNil(actual)
        XCTAssertEqual(["btc": 5.00, "usd": 2.0], actual?.data?.totalMarketCap)
        XCTAssertEqual(["btc": 10.00, "usd": 7.0], actual?.data?.totalVolume)
        XCTAssertEqual(["btc": 100.0], actual?.data?.marketCapPercentage)
        XCTAssertEqual(2.0, actual?.data?.marketCapChangePercentage24HUsd)

    }
    
    func test_mapToMarketInfo_ShouldReturnNil_IfResponseIsNil() throws {
        let actual = sut.mapToMarketInfo(nil)
        
        XCTAssertNil(actual)
    }
    
    func test_mapToMarketInfo_ShouldReturnNil_IfDataIsNil() throws {
        let response = makeNetworkMarketInfoResponse(data: nil)
        
        let actual = sut.mapToMarketInfo(response)
        
        XCTAssertNil(actual)
    }
    
    func test_mapToNetworkInfo_ShouldReturnMarketInfo_IfDataIsNotNil() throws {
        let response = makeNetworkMarketInfoResponse()
        
        let actual = sut.mapToMarketInfo(response)
        
        XCTAssertEqual(2.0, actual?.totalMarketCap)
        XCTAssertEqual(7.0, actual?.totalMarketVolume)
        XCTAssertEqual(100.0, actual?.btcDominance)
        XCTAssertEqual(2.0, actual?.marketCapChangePercentage24HUsd)
    }
}

fileprivate func makeNetworkMarketInfo() -> NetworkMarketInfo {
    return MarketInfoFactory.makeNetworkMarketInfo(
        totalMarketCap: ["btc": 5.00, "usd": 2.0],
        totalVolume: ["btc": 10.00, "usd": 7.0],
        marketCapPercentage: ["btc": 100.0],
        marketCapChangePercentage24HUsd: 2.0
    )
}

fileprivate func makeNetworkMarketInfoResponse(
    data: NetworkMarketInfo? = makeNetworkMarketInfo()
) -> NetworkMarketInfoResponse {
    return MarketInfoFactory.makeNetworkMarketInfoResponse(data: data)
}

fileprivate let json = """
 {
 "data": {
 "total_market_cap": {
 "btc": 5.0,
 "usd": 2.0,
 },
 "total_volume": {
 "btc": 10.0,
 "usd": 7.0,
 },
 "market_cap_percentage": {
 "btc": 100.0,
 },
 "market_cap_change_percentage_24h_usd": 2.0,
 }
 }
"""
