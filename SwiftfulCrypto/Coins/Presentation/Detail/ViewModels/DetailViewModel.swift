//
//  DetailViewModel.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 12/31/23.
//

import Foundation
import Combine
import CombineSchedulers

class DetailViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var isError: Bool = false
    @Published var overviewStatistics: [StatisticViewitem] = []
    @Published var additionalStatistics: [StatisticViewitem] = []
    @Published var coinDescription: String? = nil
    @Published var websiteURL: String? = nil
    @Published var redditURL: String? = nil
    @Published var coin: Coin
    
    private let getCoinDetail: GetCoinDetail
    private let scheduler: AnySchedulerOf<DispatchQueue>
    private var cancellables = Set<AnyCancellable>()
    
    init(
        coin: Coin,
        getCoinDetail: GetCoinDetail,
        scheduler: AnySchedulerOf<DispatchQueue> = .main
    ){
        self.coin = coin
        self.getCoinDetail = getCoinDetail
        self.scheduler = scheduler
        addSubscribers()
    }
    
    private func addSubscribers() {
        getCoinDetail(coinID: coin.id)
            .handleEvents(receiveSubscription: { [weak self] _ in
                self?.isLoading = true
            })
            .receive(on: scheduler)
            .sink { [weak self] coinDetail in
                if let self = self {
                    self.isLoading = false
                    
                    if let coinDetail = coinDetail {
                        let statistics = coinDetail.statistics
                        let coinInfo = coinDetail.info
                        
                        self.coin = coinDetail.coin
                        self.overviewStatistics = statistics.overview.map { mapToViewItem($0) }
                        self.overviewStatistics = statistics.additional.map { mapToViewItem($0) }
                        self.coinDescription = coinInfo.readableDescription
                        self.websiteURL = coinInfo.links?.homepage
                        self.redditURL = coinInfo.links?.subredditURL
                        
                    } else {
                        self.isError = true
                    }
                    
                }
            }
            .store(in: &cancellables)
    }
}
