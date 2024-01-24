//
//  SwiftfulCryptoApp.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 12/29/23.
//

import SwiftUI

@main
struct SwiftfulCryptoAppLauncher {
    static func main() throws {
        if NSClassFromString("XCTestCase") == nil {
            SwiftfulCryptoApp.main()
        } else {
            TestApp.main()
        }
    }
}

struct SwiftfulCryptoApp: App {
    
    @StateObject private var launchViewModel: LaunchViewModel
    @StateObject private var homeViewModel: HomeViewModel
    @State private var showLaunchView: Bool = true
    
    
    init() {
        
        let container = DIContainer.shared
        
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        UITableView.appearance().backgroundColor = UIColor.clear
        
        _launchViewModel = StateObject(
            wrappedValue: LaunchViewModel(sync: container.sync)
        )
        
        _homeViewModel = StateObject(
            wrappedValue: HomeViewModel(
                sync: container.sync,
                getMarketInfo: container.getMarketInfo,
                getCoins: container.getCoins,
                getPortfolios: container.getPortfolios,
                managePortfolio: container.managePortfolio
            )
        )
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationView {
                    HomeContainerView()
                        .toolbar(.hidden)
                }
                .tint(Color.theme.accent)
                .navigationViewStyle(.stack)
                .environmentObject(homeViewModel)
                
                ZStack {
                    if showLaunchView {
                        LaunchView(
                            showLaunchView: $showLaunchView,
                            viewModel: launchViewModel
                        )
                        .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2.0)
            }
        }
    }
}

struct TestApp: App {
    var body: some Scene {
        WindowGroup {
            EmptyView()
        }
    }
}
