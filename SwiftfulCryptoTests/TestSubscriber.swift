//
//  TestSubscriber.swift
//  SwiftfulCryptoTests
//
//  Created by Kwabena Berko on 1/12/24.
//

import Foundation
import Combine

class TestSubscriber<T> {
    private(set) var values = [T]()
    private var cancellables = Set<AnyCancellable>()
    
    init(_ publisher: AnyPublisher<T, Never>) {
        publisher.sink { [weak self] value in
            self?.values.append(value)
        }
        .store(in: &cancellables)
    }
}
