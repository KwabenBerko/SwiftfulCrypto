//
//  CoinRepository.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 1/2/24.
//

import Foundation
import CoreData
import Alamofire
import Combine
import CombineSchedulers

class RealCoinRepository: CoinRepository {
    private let context: NSManagedObjectContext
    private let defaults: UserDefaults
    private let session: Session
    private let mapToEntity: (NSManagedObjectContext, NetworkCoin?) -> CoinEntity?
    private let mapToCoin: (CoinEntity?) -> Coin?
    private let mapToCoinInfo: (NetworkCoinInfo?) -> CoinInfo?
    private let dateProvider: DateProvider
    
    init(
        context: NSManagedObjectContext,
        defaults: UserDefaults,
        session: Session,
        mapToEntity: @escaping (NSManagedObjectContext, NetworkCoin?) -> CoinEntity?,
        mapToCoin: @escaping (CoinEntity?) -> Coin?,
        mapToCoinInfo: @escaping (NetworkCoinInfo?) -> CoinInfo?,
        dateProvider: DateProvider
    ) {
        self.context = context
        self.defaults = defaults
        self.session = session
        self.mapToEntity = mapToEntity
        self.mapToCoin = mapToCoin
        self.mapToCoinInfo = mapToCoinInfo
        self.dateProvider = dateProvider
    }
    
    var syncStatus: AnyPublisher<SyncStatus, Never> {
        return defaults.publisher(for: \.coinsSyncStatus)
            .map { $0.toSyncStatus() }
            .eraseToAnyPublisher()
    }
    
    var hasCompletedInitialSync: AnyPublisher<Bool, Never> {
        return defaults.publisher(for: \.coinsLastRefreshed)
            .map { $0 != nil }
            .eraseToAnyPublisher()
    }
    
    var coins: AnyPublisher<[Coin], Never> {
        let request = CoinEntity.fetchRequest()
        
        return context.publisher(for: request)
            .map { [weak self] entities in
                return entities.compactMap { entity in
                    self?.mapToCoin(entity)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func getCoin(coinID: String) -> AnyPublisher<Coin?, Never> {
        return coins.map { entities in
            return entities.first(where: { $0.id == coinID })
        }
        .eraseToAnyPublisher()
    }
    
    func getCoinInfo(coinID: String) -> AnyPublisher<CoinInfo?, Never> {
        guard let url = URL(string: APIEndpoint.coinInfo(coinID: coinID))
        else {
            return Just(nil)
                .eraseToAnyPublisher()
        }
        

        return session.request(url)
            .publishDecodable(type: NetworkCoinInfo.self)
            .map { [weak self] response in
                if response.error != nil {
                    print("Error fetching coin details for \(coinID). \(response.error.debugDescription)")
                }
                guard let network = response.value
                else{
                    return nil
                }
                
                return self?.mapToCoinInfo(network)
            }
            .eraseToAnyPublisher()
    }
    
    func sync() async -> Bool {
        guard let url = URL(string: APIEndpoint.coins())
        else {
            return false
        }
        
        setStatus(.inProgress)
        let task = session.request(url).serializingDecodable([NetworkCoin].self)
        let response = await task.response
        if response.error != nil {
            print("Error fetching coins. \(response.error.debugDescription)")
            setStatus(.failed)
            return false
        }
        
        if let networkCoins = response.value {
            
            context.deleteAll(type: CoinEntity.self)
            
            networkCoins.forEach { networkCoin in
                let _ = mapToEntity(context, networkCoin)
            }
            
            setStatus(.success)
            context.applyChanges()
        }
        
        if defaults.coinsLastRefreshed == nil {
            defaults.coinsLastRefreshed = dateProvider.now()
        }
        return true
    }
    
    private func setStatus(_ status: SyncStatus) {
        defaults.coinsSyncStatus = status.rawValue
    }
}


extension UserDefaults {
    static let coinsSyncStatus = "coins_sync_status"
    static let coinsLastRefreshed = "coins_last_refreshed"
    
    @objc var coinsSyncStatus: String? {
        get {
            return string(forKey: Self.coinsSyncStatus)
        }
        set {
            set(newValue, forKey: Self.coinsSyncStatus)
        }
    }
    
    @objc var coinsLastRefreshed: Date? {
        get {
            return object(forKey: Self.coinsLastRefreshed) as? Date
        }
        set {
            set(newValue, forKey: Self.coinsLastRefreshed)
        }
    }
}
