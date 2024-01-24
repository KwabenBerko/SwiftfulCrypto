//
//  UserDefaults.swift
//  SwiftfulCryptoTests
//
//  Created by Kwabena Berko on 1/4/24.
//

import Foundation

extension UserDefaults {
    static var inMemory: UserDefaults {
        let defaults = UserDefaults(suiteName: #file)!
        defaults.removePersistentDomain(forName: #file)
        
        return defaults
    }
}
