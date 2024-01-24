//
//  UserDefaults.swift
//  SwiftfulCryptoTests
//
//  Created by Kwabena Berko on 1/4/24.
//

import Foundation
import Alamofire
import Mocker

extension Session {
    static var inMemory: Session {
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        return Session(configuration: configuration)
    }
}
