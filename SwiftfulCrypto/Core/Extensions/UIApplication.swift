//
//  UIApplication.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 12/30/23.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
