//
//  XMarkButton.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 12/30/23.
//

import SwiftUI

struct XMarkButton: View {
    
    var onTap: () -> Void
    
    var body: some View {
        Button {
            onTap()
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
        }
    }
}

#Preview {
    XMarkButton(onTap: {})
}
