//
//  ThemeColor.swift
//  EZMacker
//
//  Created by 박유경 on 5/6/24.
//

import SwiftUI

enum ThemeColorType {
    case white, black, cyan, orange
    case darkBlue, darkBrown, darkGray
    case lightGray, lightDark, lightWhite, lightBlue, lightBlack, lightGreen, lightYellow, lightRed
    case softWhite, softGray
    case lightModeLavender, lightModeMint, lightModeSky // TODO: 나중에 고를것
    case darkModeSlateGray
    
    var color: Color {
        switch self {
        case .white: return Color(red: 255/255, green: 255/255, blue: 255/255)
        case .black: return Color(red: 0/255, green: 0/255, blue: 0/255)
        case .cyan: return Color(red: 90/255, green: 180/255, blue: 180/255)
        case .orange: return Color(red: 217/255, green: 108/255, blue: 80/255)
        case .darkBlue: return Color(red: 84/255, green: 100/255, blue: 130/255)
        case .darkBrown: return Color(red: 51/255, green: 0/255, blue: 0/255)
        case .darkGray: return Color(red: 180/255, green: 180/255, blue: 180/255)
        case .lightGray: return Color(red: 227/255, green: 225/255, blue: 225/255)
        case .lightWhite: return Color(red: 232/255, green: 232/255, blue: 232/255)
        case .lightDark: return Color(red: 63/255, green: 61/255, blue: 71/255)
        case .lightBlue: return Color(red: 51/255, green: 176/255, blue: 200/255)
        case .lightBlack: return Color(red: 10/255, green: 10/255, blue: 10/255)
        case .lightGreen: return Color(red: 100/255, green: 200/255, blue: 100/255)
        case .lightYellow: return Color(red: 220/255, green: 220/255, blue: 10/255)
        case .lightRed: return Color(red: 204/255, green: 0/255, blue: 51/255)
        case .softWhite: return Color(red: 232/255, green: 232/255, blue: 232/255).opacity(0.4)
        case .softGray: return Color(red: 227/255, green: 225/255, blue: 225/255).opacity(0.2)
        case .lightModeLavender: return Color(red: 245/255, green: 245/255, blue: 220/255)
        case .lightModeMint: return Color(red: 230/255, green: 255/255, blue: 230/255)
        case .lightModeSky: return Color(red: 240/255, green: 248/255, blue: 255/255)
        case .darkModeSlateGray: return Color(red: 36/255, green: 46/255, blue: 66/255)
        }
    }
}
