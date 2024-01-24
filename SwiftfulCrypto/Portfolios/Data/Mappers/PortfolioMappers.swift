//
//  PortfolioEntityToPortfolioMapper.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 1/5/24.
//

import Foundation

struct PortfolioMappers {
    private init(){}
    
    static func mapToPortfolio(_ input: PortfolioEntity?) -> Portfolio? {
        guard let input = input
        else {
            return nil
        }
        return Portfolio(coinID: input.coinID!, amount: input.amount)
    }
}
