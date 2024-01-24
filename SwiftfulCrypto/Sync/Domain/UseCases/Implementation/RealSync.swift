//
//  RealSync.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 1/3/24.
//

import Foundation
import Combine
import CombineExt

class RealSync: Sync {
    let repositories: [SyncableRepository]
    
    init(repositories: [SyncableRepository]) {
        self.repositories = repositories
    }
    
    var syncStatus: AnyPublisher<SyncStatus, Never> {
        let publishers = repositories.map { $0.syncStatus }
        return publishers.combineLatest()
            .map { [weak self] list in
                if let self = self {
                    return self.aggregateSyncStatus(list)
                }
                return .none
            }
            .eraseToAnyPublisher()
    }
    
    var hasCompletedInitialSync: AnyPublisher<Bool, Never> {
        let publishers = repositories.map { $0.hasCompletedInitialSync }
        return publishers.combineLatest()
            .map { [weak self] list in
                if let self = self {
                    return self.aggregateHasCompletedInitialSync(list)
                }
                return false
            }
            .eraseToAnyPublisher()
    }
    
    func callAsFunction() async -> Bool {
        let results = await withTaskGroup(of: Bool.self, returning: [Bool].self) { group in
            for repository in repositories {
                group.addTask { await repository.sync() }
            }
            
            var taskResults = [Bool]()
            for await result in group {
                taskResults.append(result)
            }
            
            return taskResults
        }
        
        return !results.contains(false)
    }

    
    private func aggregateSyncStatus(_ list: [SyncStatus]) -> SyncStatus {
        if list.contains(.none) {
            return .none
        } else if list.contains(.inProgress) {
            return .inProgress
        } else if list.contains(.failed) {
            return .failed
        } else {
            return SyncStatus.success
        }
    }
    
    private func aggregateHasCompletedInitialSync(_ list: [Bool]) -> Bool {
        return !list.contains(false)
    }
}
