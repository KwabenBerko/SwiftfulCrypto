//
//  LaunchViewModel.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 1/3/24.
//

import Foundation
import Combine

class LaunchViewModel: ObservableObject {
    @Published var hasCompletedSync: Bool = false
    private var cancellables = Set<AnyCancellable>()
    private let sync: Sync
    
    init(sync: Sync) {
        self.sync = sync
        checkAndPerformInitialSyncIfNeeded()
    }
    
    private func checkAndPerformInitialSyncIfNeeded() {
        sync.hasCompletedInitialSync
            .first()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isCompleted in
                print("Has Completed Initial Sync?: \(isCompleted)")
                if !isCompleted {
                    self?.performInitialSync()
                } else {
                    DispatchQueue.main.async {
                        self?.hasCompletedSync = true
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func performInitialSync() {
        Task {
            let result = await sync()
            DispatchQueue.main.async {
                if !result {
                    print("An Error occured during initial sync.")
                } else {
                    self.hasCompletedSync = true
                }
            }
        }
    }
}
