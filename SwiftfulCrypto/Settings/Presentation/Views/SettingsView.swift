//
//  SettingsView.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 12/31/23.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.dismiss) var dismiss: DismissAction
    let defaultURl = URL(string: "https://www.google.com")!
    let youtubeURL = URL(string: "https://www.youtube.com/c/swiftfulthinking")!
    let coffeeURL = URL(string: "https://www.buymeacoffee.com/nicksarno")!
    let coinGeckoURL = URL(string: "https://www.coingecko.com")!
    let personalURL = URL(string: "https://github.com/KwabenBerko")!
    
    var body: some View {
        NavigationView {
            List{
                swiftfulThinkingSection
                    .listRowBackground(Color.theme.background.opacity(0.5))
                coinGeckoSection
                    .listRowBackground(Color.theme.background.opacity(0.5))
                developerSection
                    .listRowBackground(Color.theme.background.opacity(0.5))
                applicationSection
                    .listRowBackground(Color.theme.background.opacity(0.5))
            }
            .scrollContentBackground(.hidden)
            .background(Color.theme.background.ignoresSafeArea())
            .font(.headline)
            .tint(.blue)
            .listStyle(.grouped)
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    XMarkButton {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}


extension SettingsView {
    private var swiftfulThinkingSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("This app was made by following a @SwiftfulThinking course on Youtube . It uses MVVM Architecture, Combine, and CoreData.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Subscribe on Youtube 🥳", destination: youtubeURL)
            Link("Support his coffee addiction ☕️", destination: coffeeURL)
        } header: {
            Text("Swiftful Thinking")
        }
    }
    
    private var coinGeckoSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("The cryptocurrency data that is used in this app comes from a free API from CoinGecko. Prices may be slightly delayed.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Visit CoinGecko 🦎", destination: coinGeckoURL)
        } header: {
            Text("CoinGecko")
        }
    }
    
    private var developerSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("developer")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("This app was developed by Kwabena Bio Berko. It uses SwiftUI and it's written 100% in Swift. The project benefits from multi-threading, publishers/subscribers, and data persistence.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Visit Website 🤙", destination: personalURL)
        } header: {
            Text("Developer")
        }
    }
    
    private var applicationSection: some View {
        Section {
            Link("Terms of Service", destination: defaultURl)
            Link("Privacy Policy", destination: defaultURl)
            Link("Company Website", destination: defaultURl)
            Link("Learn more", destination: defaultURl)
        } header: {
            Text("Application")
        }
    }
}
