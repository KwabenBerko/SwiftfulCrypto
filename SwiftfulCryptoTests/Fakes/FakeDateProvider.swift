//
//  FakeTimeProvider.swift
//  SwiftfulCryptoTests
//
//  Created by Kwabena Berko on 1/5/24.
//

import Foundation
@testable import SwiftfulCrypto

class FakeDateProvider: DateProvider {
    private var date: Date
    
    init(_ date: Date = Date()) {
        self.date = date
    }
    
    func setNow(date: Date){
        self.date = date
    }
    
    func now() -> Date {
        return self.date
    }
}
