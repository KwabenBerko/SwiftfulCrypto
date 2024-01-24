//
//  TimeProvider.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 1/5/24.
//

import Foundation

protocol DateProvider {
    func now() -> Date
}
