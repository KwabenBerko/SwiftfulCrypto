//
//  SyncStatusManager.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 1/3/24.
//

import Foundation
import Combine

class SetSyncStatusDelegate {
    private let key: String
    private let defaults: UserDefaults
    
    init(key: String, defaults: UserDefaults){
        self.defaults = defaults
        self.key = key
    }

    func setSyncStatus(_ status: SyncStatus) {
        defaults.setValue(status.rawValue, forKey: key)
    }
}


