//
//  HomeView.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 12/30/23.
//

import SwiftUI

struct HomeContainerView: View {
    @EnvironmentObject private var viewModel: HomeViewModel
    @State private var showPortfolioView: Bool = false
    @State private var showSettingsView: Bool = false
    @State private var showDetailView: Bool = false
    @State private var selectedCoin: Coin? = nil
    
    var body: some View {
        HomeView(
            searchText: $viewModel.searchText,
            allCoins: $viewModel.allCoins,
            portfolioCoins: $viewModel.portfolioCoins,
            sortOption: $viewModel.sortOption,
            statistics: $viewModel.statistics,
            isSyncing: $viewModel.isSyncing,
            refresh: viewModel.refresh,
            navigateToSettings: {
                showSettingsView.toggle()
            },
            navigateToPortfolio: {
                showPortfolioView.toggle()
            },
            navigateToDetail: { coin in
                selectedCoin = coin
                showDetailView.toggle()
            }
        )
        .sheet(isPresented: $showPortfolioView){
            PortfolioContainerView()
                .environmentObject(viewModel)
        }
        .sheet(isPresented: $showSettingsView){
            SettingsView()
        }
        .background(
            NavigationLink(
                destination: DetailLoadingView(coin: $selectedCoin),
                isActive: $showDetailView,
                label: { EmptyView()})
        )
    }
}

struct HomeView: View {
    
    @Binding var searchText: String
    @Binding var allCoins: [Coin]
    @Binding var portfolioCoins: [Coin]
    @Binding var sortOption: SortOption
    @Binding var statistics: [StatisticViewitem]
    @Binding var isSyncing: Bool
    let refresh: () -> Void
    let navigateToSettings: () -> Void
    let navigateToPortfolio: () -> Void
    let navigateToDetail: (Coin) -> Void
    
    @State private var showPortfolio: Bool = false
    
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            VStack {
                homeHeader
                
                HomeStatsView(
                    statistics: $statistics,
                    showPortfolio: $showPortfolio
                )
                
                SearchBarView(searchText: $searchText)
                
                columnTitles
                
                if !showPortfolio {
                    allCoinsList
                        .transition(.move(edge: .leading))
                }
                
                if showPortfolio {
                    ZStack(alignment: .top) {
                        if portfolioCoins.isEmpty && searchText.isEmpty {
                            portfolioEmptyText
                        } else {
                            portfolioCoinsList
                        }
                    }
                    .transition(.move(edge: .trailing))
                }
                
                Spacer(minLength: 0)
            }
        }
    }
}

extension HomeView {
    private var homeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .transaction { transaction in
                    transaction.animation = nil
                }
                .onTapGesture {
                    if showPortfolio {
                        navigateToPortfolio()
                    } else {
                        navigateToSettings()
                    }
                }
                .background(
                    CircleButtonAnimationView(animate: $showPortfolio)
                )
            
            Spacer()
            
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundStyle(Color.theme.accent)
                .animation(.none)
            
            Spacer()
            
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(
                    Angle(degrees: showPortfolio ? 180 : 0)
                )
                .onTapGesture {
                    withAnimation(.spring){
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    
    private var allCoinsList: some View {
        List {
            ForEach(allCoins){ coin in
                CoinRowView(coin: coin, showHoldings: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        navigateToDetail(coin)
                    }
                    .listRowBackground(Color.theme.background)
            }
        }
        .listStyle(.plain)
    }
    
    private var portfolioCoinsList: some View {
        List {
            ForEach(portfolioCoins){ coin in
                CoinRowView(coin: coin, showHoldings: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        navigateToDetail(coin)
                    }
                    .listRowBackground(Color.theme.background)
            }
        }
        .listStyle(.plain)
    }
    
    private var portfolioEmptyText: some View {
        Text("You haven't added any coins to your portfolio yet! Click the + button to get started!. 🧐")
            .font(.callout)
            .foregroundStyle(Color.theme.accent)
            .fontWeight(.medium)
            .multilineTextAlignment(.center)
            .padding(50)
    }
    
    private var columnTitles: some View {
        HStack {
            HStack(spacing: 4) {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity(
                        (sortOption == .rank || sortOption == .rankReversed) ? 1.0 : 0.0
                    )
                    .rotationEffect(Angle(degrees: sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default){
                    sortOption = sortOption == .rank ? .rankReversed : .rank
                }
            }
            Spacer()
            if showPortfolio {
                HStack(spacing: 4) {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity(
                            (sortOption == .holdings || sortOption == .holdingsReversed) ? 1.0 : 0.0
                        )
                        .rotationEffect(Angle(degrees: sortOption == .holdings ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation(.default){
                        sortOption = sortOption == .holdings ? .holdingsReversed : .holdings
                    }
                }
            }
            
            HStack(spacing: 4){
                Text("Price")
                    .frame(
                        width: UIScreen.main.bounds.width / 3.5,
                        alignment: .trailing
                    )
                Image(systemName: "chevron.down")
                    .opacity(
                        (sortOption == .price || sortOption == .priceReversed) ? 1.0 : 0.0
                    )
                    .rotationEffect(Angle(degrees: sortOption == .price ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default){
                    sortOption = sortOption == .price ? .priceReversed : .price
                }
            }
            
            Button {
                refresh()
            } label: {
                Image(systemName: "goforward")
            }
            .rotationEffect(
                Angle(degrees: isSyncing ? 360: 0),
                anchor: .center
            )
            .animation(
                isSyncing ? .linear.repeatForever(autoreverses: false): .default,
                value: isSyncing
            )
        }
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryText)
        .padding(.horizontal)
    }
}

#Preview {
    let coin = CoinFactory.makeCoin()
    let statistic = StatisticFactory.makeStatisticViewItem()
    
    return HomeView(
        searchText: .constant(""),
        allCoins: .constant([coin, coin, coin]),
        portfolioCoins: .constant([coin, coin]),
        sortOption: .constant(SortOption.price),
        statistics: .constant([statistic, statistic, statistic]),
        isSyncing: .constant(false),
        refresh: {},
        navigateToSettings: {},
        navigateToPortfolio: {},
        navigateToDetail: {_ in }
    )
}
