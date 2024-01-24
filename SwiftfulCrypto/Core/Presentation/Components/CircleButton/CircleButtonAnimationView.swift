//
//  CircleButtonAnimationView.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 12/30/23.
//

import SwiftUI

struct CircleButtonAnimationView: View {
    
    @Binding var animate: Bool
    
    var body: some View {
        Circle()
            .stroke(lineWidth: 5.0)
            .scale(animate ? 1.0 : 0.0)
            .opacity(animate ? 0.0 : 1.0)
            .transaction { transaction in
                transaction.animation = animate ? Animation.easeInOut(duration: 1.0) : nil
            }
    }
}

#Preview {
    CircleButtonAnimationView(animate: .constant(false))
        .foregroundStyle(.red)
        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
}
