//
//  HomeViewModel.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 12/30/23.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var statistics: [StatisticViewitem] = [StatisticViewitem(statistic: Statistic(title: .currentPrice, value: .amount(10)), formattedValue: "$10")]
    
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    @Published var isSyncing: Bool = true
    @Published var searchText = ""
    @Published var sortOption: SortOption = .holdings
    
    private var cancellables = Set<AnyCancellable>()
    private let sync: Sync
    private let getMarketInfo: GetMarketInfo
    private let getCoins: GetCoins
    private let getPortfolios: GetPortfolios
    private let managePortfolio: ManagePortfolio
    
    
    init(
        sync: Sync,
        getMarketInfo: GetMarketInfo,
        getCoins: GetCoins,
        getPortfolios: GetPortfolios,
        managePortfolio: ManagePortfolio
    ) {
        self.sync = sync
        self.getMarketInfo = getMarketInfo
        self.getCoins = getCoins
        self.getPortfolios = getPortfolios
        self.managePortfolio = managePortfolio
        addSubscribers()
    }
    
    func refresh() {
        Task {
            await sync()
        }
        HapticManager.notification(type: .success)
    }
    
    func updatePortfolio(coin: Coin, amount: Double) {
        Task {
            await managePortfolio(coinID: coin.id, amount: amount)
        }
    }
    
    private func addSubscribers() {
        
        sync.syncStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                switch status {
                case .inProgress:
                    self?.isSyncing = true
                default:
                    self?.isSyncing = false
                }
            }
            .store(in: &cancellables)
        
        $searchText
            .combineLatest(getCoins(), $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] coins in
                self?.allCoins = coins
            }
            .store(in: &cancellables)
        
        
        getPortfolios()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] coins in
                guard let self = self
                else {
                    return
                }
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: coins)
            }
            .store(in: &cancellables)
        
        getMarketInfo()
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] stats in
                if let self = self {
                    self.statistics = stats.map { mapToViewItem($0) }
                }
            }
            .store(in: &cancellables)
    }
    
    private func filterAndSortCoins(
        text: String,
        coins: [Coin],
        sort: SortOption
    ) -> [Coin] {
        let filteredCoins = filterCoins(text: text, coins: coins)
        return sortCoins(sort: sort, coins: filteredCoins)
    }
    
    private func filterCoins(text: String, coins: [Coin]) -> [Coin] {
        guard !text.isEmpty else {
            return coins
        }
        
        let lowercasedText = text.lowercased()
        return coins.filter { coin in
            return coin.name.lowercased().contains(lowercasedText) ||
            coin.symbol.lowercased().contains(lowercasedText) ||
            coin.id.lowercased().contains(lowercasedText)
        }
    }
    
    private func sortCoins(sort: SortOption, coins: [Coin]) -> [Coin] {
        switch sort {
        case .rank, .holdings:
            return coins.sorted(by: { $0.rank < $1.rank })
        case.rankReversed, .holdingsReversed:
            return coins.sorted(by: { $0.rank > $1.rank })
        case.price:
            return coins.sorted(by: { $0.currentPrice > $1.currentPrice })
        case.priceReversed:
            return coins.sorted(by: { $0.currentPrice < $1.currentPrice })
        }
    }
    
    private func sortPortfolioCoinsIfNeeded(coins: [Coin]) -> [Coin] {
        switch sortOption {
        case .holdings:
            return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue })
        case .holdingsReversed:
            return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue })
        default:
            return coins
        }
    }
    
    private func mapGlobalMarketData(
        marketDataModel: MarketInfo?,
        portfolioCoins: [Coin]
    ) -> [Statistic] {
        var stats: [Statistic] = []
        
        guard let data = marketDataModel
        else {
            return stats
        }
        
        let marketCap = Statistic(
            title: .totalMarketCap,
            value: data.totalMarketCap.flatMap { .amount($0) },
            percentageChange: data.marketCapChangePercentage24HUsd
        )
        
        let volume = Statistic(
            title: .totalMarketVolume,
            value: data.totalMarketVolume.flatMap { .amount($0) }
        )
        let btcDominance = Statistic(
            title: .btcDominance,
            value: data.btcDominance.flatMap { .amount($0) }
        )
        
        let portfolioValue = portfolioCoins
            .map { $0.currentHoldingsValue }
            .reduce(0, +)
        
        let previousValue = portfolioCoins
            .map { (coin) -> Double in
                let current = coin.currentHoldingsValue
                let percentChange = coin.priceChangePercentage24H
                let previous = current / (1 + percentChange)
                return previous
            }
            .reduce(0, +)
        
        
        let percentageChange = previousValue == 0 ? 0 : ((portfolioValue - previousValue) / previousValue)
        
        let portfolio = Statistic(
            title: .portfolioValue,
            value: .amount(portfolioValue),
            percentageChange: percentageChange
        )
        
        stats.append(contentsOf: [marketCap, volume, btcDominance, portfolio])
        
        return stats
    }
}

enum SortOption {
    case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
}

