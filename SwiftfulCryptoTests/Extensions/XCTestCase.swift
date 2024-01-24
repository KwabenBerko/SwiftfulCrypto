//
//  XCTestCase.swift
//  SwiftfulCryptoTests
//
//  Created by Kwabena Berko on 1/2/24.
//

import XCTest
import Combine

extension XCTestCase {
    
    func bundle(forResource: String, withExtension: String) -> URL {
        return Bundle(for: type(of: self)).url(forResource: forResource, withExtension: withExtension)!
    }
}

