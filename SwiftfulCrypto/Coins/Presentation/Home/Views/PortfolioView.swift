//
//  PortfolioView.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 12/30/23.
//

import SwiftUI

struct PortfolioContainerView: View {
    @EnvironmentObject private var viewModel: HomeViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        PortfolioView(
            searchText: $viewModel.searchText,
            allCoins: $viewModel.allCoins,
            portfolioCoins: $viewModel.portfolioCoins,
            save: { coin, amount in
                viewModel.updatePortfolio(coin: coin, amount: amount)
            },
            dismiss: {
                dismiss()
            }
        )
    }
}

struct PortfolioView: View {
    @Binding var searchText: String
    @Binding var allCoins: [Coin]
    @Binding var portfolioCoins: [Coin]

    var save: (Coin, Double) -> Void
    var dismiss: () -> Void
    
    @State private var quantityText: String = ""
    @State private var selectedCoin: Coin? = nil
    @State private var showCheckmark: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0){
                    SearchBarView(searchText: $searchText)
                    coinLogoList
                    
                    if(selectedCoin != nil) {
                        portfolioInputSection
                    }
                }
            }
            .background(Color.theme.background.ignoresSafeArea())
            .navigationTitle("Edit Portfolio")
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading){
                    XMarkButton {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing){
                    trailingNavBarButtons
                }
            })
            .onChange(of: searchText) { _, value in
                if value == "" {
                    removeSelectedCoin()
                }
            }
        }
    }
}

#Preview {
    let coins = [CoinFactory.makeCoin()]
    return PortfolioView(
        searchText: .constant("Bitcoin"),
        allCoins: .constant(coins),
        portfolioCoins: .constant(coins),
        save: { _, _ in },
        dismiss: { }
    )
}

extension PortfolioView {
    private var coinLogoList: some View {
        ScrollView(.horizontal){
            LazyHStack(spacing: 10) {
                ForEach(searchText.isEmpty ? portfolioCoins : allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                updateSelectedCoin(coin: coin)
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    selectedCoin?.id == coin.id ?
                                    Color.theme.green : Color.clear,
                                    lineWidth: 1
                                )
                        )
                }
            }
            .frame(height: 120)
            .padding(.leading)
        }
        .scrollIndicators(.hidden)
    }
    
    private var portfolioInputSection: some View {
        VStack(spacing: 20){
            HStack {
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""): ")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            
            Divider()
            
            HStack {
                Text("Amount holding:")
                Spacer()
                TextField("Ex: 1.4", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            
            Divider()
            
            HStack {
                Text("Current value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
        }
        .transaction { transaction in
            transaction.animation = nil
        }
        .padding()
        .font(.headline)
    }
    
    private var trailingNavBarButtons: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark")
                .opacity(showCheckmark ? 1.0 : 0.0)
            
            Button {
                saveButtonPressed()
            } label: {
                Text("Save".uppercased())
            }
            .opacity(
                (selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText)) ?
                1.0: 0.0
            )
        }
        .font(.headline)
    }
    
    private func getCurrentValue() -> Double {
        if let quantity = Double(quantityText) {
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
    private func saveButtonPressed() {
        guard let coin = selectedCoin,
              let amount = Double(quantityText)
        else {
            return
        }
        
        
        save(coin, amount)
        
        withAnimation(.easeIn) {
            showCheckmark = true
            removeSelectedCoin()
        }
        
        UIApplication.shared.endEditing()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeOut){
                showCheckmark = false
            }
        }
    }
    
    private func updateSelectedCoin(coin: Coin) {
        selectedCoin = coin
        
        if let portfolioCoin = portfolioCoins.first(where: { $0.id == coin.id }){
            let amount = portfolioCoin.currentHoldings
            quantityText = "\(amount)"
        } else {
            quantityText = ""
        }
        
    }
    
    private func removeSelectedCoin() {
        selectedCoin = nil
        searchText = ""
    }
}
