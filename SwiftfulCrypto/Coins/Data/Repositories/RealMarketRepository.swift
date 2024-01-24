//
//  RealMarketRepository.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 1/2/24.
//

import Foundation
import CoreData
import Alamofire
import Combine

class RealMarketRepository: MarketRepository {
    private let context: NSManagedObjectContext
    private let defaults: UserDefaults
    private let session: Session
    private let mapToString: (NetworkMarketInfoResponse) -> String?
    private let mapToNetwork: (String) -> NetworkMarketInfoResponse?
    private let mapToMarketInfo: (NetworkMarketInfoResponse) -> MarketInfo?
    private let dateProvider: DateProvider
    
    init(
        context: NSManagedObjectContext,
        defaults: UserDefaults,
        session: Session,
        mapToString: @escaping (NetworkMarketInfoResponse) -> String?,
        mapToNetwork: @escaping (String) -> NetworkMarketInfoResponse?,
        mapToMarketInfo: @escaping (NetworkMarketInfoResponse) -> MarketInfo?,
        dateProvider: DateProvider
    ) {
        self.context = context
        self.defaults = defaults
        self.session = session
        self.mapToString = mapToString
        self.mapToNetwork = mapToNetwork
        self.mapToMarketInfo = mapToMarketInfo
        self.dateProvider = dateProvider
    }
    
    var syncStatus: AnyPublisher<SyncStatus, Never> {
        return defaults.publisher(for: \.marketInfoSyncStatus)
            .map { $0.toSyncStatus() }
            .eraseToAnyPublisher()
    }
    
    var marketInfo: AnyPublisher<MarketInfo?, Never> {
        return defaults.publisher(for: \.marketInfo)
            .map { json in
                guard let json = json,
                      let network = self.mapToNetwork(json)
                else {
                    print("Its the else!")
                    return nil
                }
                
                return self.mapToMarketInfo(network)
            }
            .eraseToAnyPublisher()
    }
    
    var hasCompletedInitialSync: AnyPublisher<Bool, Never> {
        return defaults.publisher(for: \.marketInfoLastRefreshed)
            .map { $0 != nil }
            .eraseToAnyPublisher()
    }
    
    func hasCompletedInitialSync() async -> Bool {
        return defaults.marketInfoLastRefreshed != nil
    }
    
    func sync() async -> Bool {
        guard let url = URL(string: APIEndpoint.marketInfo())
        else {
            return false
        }
        
        setStatus(.inProgress)
        let task = session.request(url).serializingDecodable(NetworkMarketInfoResponse.self)
        let response = await task.response
        
        guard response.error == nil
        else {
            setStatus(.failed)
            print("Error fetching market info. \(response.error.debugDescription)")
            return false
        }
        
        guard let value = response.value,
              let json = mapToString(value)
        else {
            setStatus(.failed)
            return false
        }
        
        defaults.marketInfo = json
        setStatus(.success)
        if defaults.marketInfoLastRefreshed == nil {
            defaults.marketInfoLastRefreshed = dateProvider.now()
        }
        return true
    }
    
    private func setStatus(_ status: SyncStatus) {
        defaults.marketInfoSyncStatus = status.rawValue
    }
}

extension UserDefaults {
    static let marketInfo = "market_info"
    static let marketInfoSyncStatus = "market_info_sync_status"
    static let marketInfoLastRefreshed = "market_info_last_refreshed"
    
    @objc var marketInfo: String? {
        get {
            return string(forKey: Self.marketInfo)
        }
        set {
            set(newValue, forKey: Self.marketInfo)
        }
    }
    
    @objc var marketInfoSyncStatus: String? {
        get {
            return string(forKey: Self.marketInfoSyncStatus)
        }
        set {
            set(newValue, forKey: Self.marketInfoSyncStatus)
        }
    }
    
    @objc var marketInfoLastRefreshed: Date? {
        get {
            return object(forKey: Self.marketInfoLastRefreshed) as? Date
        }
        set {
            set(newValue, forKey: Self.marketInfoLastRefreshed)
        }
    }
}
