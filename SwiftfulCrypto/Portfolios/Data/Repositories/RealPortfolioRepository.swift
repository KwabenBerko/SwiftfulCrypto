//
//  RealPortfolioRepository.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 1/1/24.
//

import Foundation
import CoreData
import Combine

class RealPortfolioRepository: PortfolioRepository {
    
    private let context: NSManagedObjectContext
    private let mapToPortfolio: (PortfolioEntity?) -> Portfolio?
    
    init(
        context: NSManagedObjectContext,
        mapToPortfolio: @escaping (PortfolioEntity?) -> Portfolio?
    ) {
        self.context = context
        self.mapToPortfolio = mapToPortfolio
    }
    
    var portfolios: AnyPublisher<[Portfolio], Never> {
        let request = PortfolioEntity.fetchRequest()
        
        return context.publisher(for: request)
            .map{ [weak self] entities in
                entities.compactMap { entity in
                    return self?.mapToPortfolio(entity)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func getPortfolio(coinID: String) async -> Portfolio? {
        guard let entity = getEntity(coinID: coinID)
        else {
            return nil
        }
        
        return mapToPortfolio(entity)
    }
    
    func createPortfolio(coinID: String, amount: Double) async {
        let entity = PortfolioEntity(context: context)
        entity.coinID = coinID
        entity.amount = amount
        context.applyChanges()
    }
    
    func updatePortfolio(coinID: String, amount: Double) async {
        if let entity = getEntity(coinID: coinID) {
            entity.amount = amount
            context.applyChanges()
        }
    }
    
    func deletePortfolio(coinID: String) async {
        if let entity = getEntity(coinID: coinID) {
            context.delete(entity)
            context.applyChanges()
        }
    }
    
    private func getEntity(coinID: String) -> PortfolioEntity? {
        let request = PortfolioEntity.fetchRequest()
        request.predicate = NSPredicate(format: "coinID == %@", coinID)
        
        do {
            let response = try context.fetch(request)
            return response.first
        } catch _ {
            return nil
        }
    }
}
