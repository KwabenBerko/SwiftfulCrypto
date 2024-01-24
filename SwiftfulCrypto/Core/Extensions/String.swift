//
//  String.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 12/31/23.
//

import Foundation

extension String {
    var removingHTMLOccurences: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}

extension String? {
    func toSyncStatus() -> SyncStatus {
        guard let value = self
        else {
            return SyncStatus.none
        }
        
        return SyncStatus(rawValue: value) ?? SyncStatus.none
    }
}
