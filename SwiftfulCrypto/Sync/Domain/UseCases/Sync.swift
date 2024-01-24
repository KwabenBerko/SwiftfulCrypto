//
//  Sync.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 1/3/24.
//

import Foundation
import Combine

protocol Sync {
    var syncStatus: AnyPublisher<SyncStatus, Never> { get }
    var hasCompletedInitialSync: AnyPublisher<Bool, Never> { get }
    func callAsFunction() async -> Bool
}
