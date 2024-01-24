//
//  SyncableRepository.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 1/3/24.
//

import Foundation
import Combine

protocol SyncableRepository {
    var syncStatus: AnyPublisher<SyncStatus, Never> { get }
    var hasCompletedInitialSync: AnyPublisher<Bool, Never> { get }
    func sync() async -> Bool
}
