//
//  SearchBarView.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 12/30/23.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(
                    searchText.isEmpty ? Color.theme.secondaryText: Color.theme.accent
                )
            
            TextField(
                "",
                text: $searchText,
                prompt: Text("Search by name or symbol...")
                    .foregroundStyle(Color.theme.secondaryText.opacity(0.35))
            )
            .foregroundStyle(Color.theme.accent)
            .autocorrectionDisabled()
            .overlay (
                Image(systemName: "xmark.circle.fill")
                    .padding()
                    .offset(x: 10)
                    .foregroundStyle(Color.theme.accent)
                    .opacity(searchText.isEmpty ? 0.0 : 1.0)
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                        searchText = ""
                    },
                alignment: .trailing
            )
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.theme.background)
                .shadow(
                    color: Color.theme.accent.opacity(0.15),
                    radius: 10, x: 0, y: 0
                )
        )
        .padding()
    }
}

#Preview("Light", traits: .sizeThatFitsLayout) {
    SearchBarView(searchText: .constant(""))
}

#Preview("Dark", traits: .sizeThatFitsLayout) {
    SearchBarView(searchText: .constant(""))
        .preferredColorScheme(.dark)
}
