//
//  PortfolioFactory.swift
//  SwiftfulCryptoTests
//
//  Created by Kwabena Berko on 1/5/24.
//

import Foundation
import CoreData

struct PortfolioFactory {
    
    static func makePortfolio(
        coinID: String = "btc",
        amount: Double = 1.0
    ) -> Portfolio {
        return Portfolio(coinID: coinID, amount: amount)
    }
    
    static func makePortfolioEntity(
        context: NSManagedObjectContext,
        coinID: String = "btc",
        amount: Double = 1.0
    ) -> PortfolioEntity {
        let entity = PortfolioEntity(context: context)
        entity.coinID = coinID
        entity.amount = amount
        return entity
    }
}
