//
//  Container.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 1/1/24.
//

import Foundation
import CoreData
import Alamofire

class DIContainer {
    
    static let shared: DIContainer = DIContainer()
    
    private let database = SwiftfulCryptoDatabase()
    private let defaults = UserDefaults.standard
    private let session = AF
    
    private lazy var dateProvider: DateProvider = {
        RealDateProvider()
    }()
    
    private lazy var portfolioRepository: PortfolioRepository = {
        RealPortfolioRepository(
            context: database.container.viewContext,
            mapToPortfolio: PortfolioMappers.mapToPortfolio
        )
    }()
    
    private lazy var coinRepository: CoinRepository = {
        RealCoinRepository(
            context: database.container.viewContext,
            defaults: defaults,
            session: session,
            mapToEntity: CoinMappers.mapToEntity,
            mapToCoin: CoinMappers.mapToCoin,
            mapToCoinInfo: CoinMappers.mapToCoinInfo,
            dateProvider: dateProvider
        )
    }()
    
    private lazy var marketRepository: MarketRepository = {
        RealMarketRepository(
            context: database.container.viewContext,
            defaults: defaults,
            session: session,
            mapToString: MarketInfoMappers.mapToString,
            mapToNetwork: MarketInfoMappers.mapToNetwork,
            mapToMarketInfo: MarketInfoMappers.mapToMarketInfo,
            dateProvider: dateProvider
        )
    }()
    
    lazy var sync: Sync = {
        let repositories = [coinRepository, marketRepository]
        return RealSync(repositories: repositories)
    }()
    
    lazy var managePortfolio: ManagePortfolio = {
        RealManagePortfolio(repository: portfolioRepository)
    }()
    
    lazy var getPortfolios: GetPortfolios = {
        RealGetPortfolios(
            portfolioRepository: portfolioRepository,
            coinRepository: coinRepository
        )
    }()
    
    lazy var getCoins: GetCoins = {
        RealGetCoins(repository: coinRepository)
    }()
    
    lazy var getCoinDetail: GetCoinDetail = {
        RealGetCoinDetail(repository: coinRepository)
    }()
    
    lazy var getMarketInfo: GetMarketInfo = {
        RealGetMarketInfo(repository: marketRepository)
    }()
    
}
