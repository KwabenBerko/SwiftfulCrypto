//
//  Color.swift
//  SwiftfulCrypto
//
//  Created by Kwabena Berko on 12/30/23.
//

import Foundation
import SwiftUI

extension Color {
    
    static let theme = AlternateTheme()
    static let launch = LaunchTheme()
    
}

protocol ColorTheme {
    var accent: Color { get }
    var background: Color { get }
    var green: Color { get }
    var red: Color { get }
    var secondaryText: Color { get }
}

struct DefaultTheme: ColorTheme {
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let green = Color("GreenColor")
    let red = Color("RedColor")
    let secondaryText = Color("SecondaryTextColor")
}

struct AlternateTheme: ColorTheme {
    let accent = Color(#colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1))
    let background = Color(#colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1))
    let green = Color(#colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1))
    let red = Color(#colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1))
    let secondaryText = Color(#colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1))
}

struct LaunchTheme: ColorTheme {
    let accent = Color("LaunchAccentColor")
    let background = Color("LaunchBackgroundColor")
    var green = Color.clear
    var red = Color.clear
    var secondaryText = Color.clear
}
