//
//  DetailView.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 12/31/23.
//

import SwiftUI

struct DetailLoadingView: View {
    
    @Binding var coin: Coin?
    
    var body: some View {
        ZStack {
            if let coin = coin {
                DetailContainerView(coin: coin)
            }
        }
    }
}

struct DetailContainerView: View{
    @StateObject private var viewModel: DetailViewModel
    
    init(coin: Coin) {
        _viewModel = StateObject(
            wrappedValue: DetailViewModel(
                coin: coin,
                getCoinDetail: DIContainer.shared.getCoinDetail
            )
        )
    }
    
    var body: some View {
        DetailView(
            isLoading: $viewModel.isLoading,
            isError: $viewModel.isError,
            coin: $viewModel.coin,
            overviewStatistics: $viewModel.overviewStatistics,
            additionalStatistics: $viewModel.additionalStatistics,
            coinDescription: $viewModel.coinDescription,
            websiteURL: $viewModel.websiteURL,
            redditURL: $viewModel.redditURL
        )
    }
}

struct DetailView: View {
    @Binding var isLoading: Bool
    @Binding var isError: Bool
    @Binding var coin: Coin
    @Binding var overviewStatistics: [StatisticViewitem]
    @Binding var additionalStatistics: [StatisticViewitem]
    @Binding var coinDescription: String?
    @Binding var websiteURL: String?
    @Binding var redditURL: String?
    
    @State private var showFullDescription: Bool = false
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    private let spacing: CGFloat = 20
    
    var body: some View {
        ZStack {
            
            Color.theme.background
                .ignoresSafeArea()
            
            if isLoading {
                ProgressView()
            } else if isError {
                Text("Unable to load coin details.")
            } else {
                ScrollView {
                    VStack {
                        ChartView(coin: coin)
                            .padding(.vertical)
                        
                        VStack(spacing: 20) {
                            overviewTitle
                            Divider()
                            descriptionSection
                            overviewGrid
                            
                            additionalTitle
                            Divider()
                            additionalGrid
                            websiteSection
                        }
                        .padding()
                    }
                }
            }
        }
        .navigationTitle(coin.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                navigationBarTrailingItems
            }
        }
    }
}

extension DetailView {
    private var overviewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var overviewGrid: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: [],
            content: {
                ForEach(overviewStatistics, id: \.statistic.title) { item in
                    StatisticView(item: item)
                }
            })
    }
    
    
    private var additionalTitle: some View {
        Text("Addition Details")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var additionalGrid: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: [],
            content: {
                ForEach(additionalStatistics, id: \.statistic.title) { item in
                    StatisticView(item: item)
                }
            })
    }
    
    
    private var descriptionSection: some View {
        ZStack {
            if let coinDescription = coinDescription,
               !coinDescription.isEmpty {
                VStack(alignment: .leading) {
                    Text(coinDescription)
                        .lineLimit(showFullDescription ? nil : 3)
                        .font(.callout)
                        .foregroundStyle(Color.theme.secondaryText)
                    
                    Button {
                        withAnimation(.easeInOut){
                            showFullDescription.toggle()
                        }
                    } label: {
                        Text(showFullDescription ? "Less" : "Read more")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical, 4)
                    }
                    .tint(Color.blue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    private var websiteSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let websiteString = websiteURL,
               let url = URL(string: websiteString) {
                Link("Website", destination: url)
            }
            
            if let redditString = redditURL,
               let url = URL(string: redditString) {
                Link("Reddit", destination: url)
            }
        }
        .tint(Color.blue)
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.headline)
    }
    
    private var navigationBarTrailingItems: some View {
        HStack {
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundStyle(Color.theme.secondaryText)
            CoinImageView(imageURL: coin.image)
                .frame(width: 25, height: 25)
        }
    }
}


#Preview {
    let detail = CoinDetailFactory.makeCoinDetail()
    return DetailView(
        isLoading: .constant(false),
        isError: .constant(false),
        coin: .constant(detail.coin),
        overviewStatistics: .constant([]),
        additionalStatistics: .constant([]),
        coinDescription: .constant(detail.info.readableDescription),
        websiteURL: .constant(detail.info.links?.homepage),
        redditURL: .constant(detail.info.links?.subredditURL)
    )
}
