//
//  HapticManager.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 12/31/23.
//

import Foundation
import SwiftUI

class HapticManager {
    private static let generator = UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
}
