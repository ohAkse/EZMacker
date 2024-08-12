//
//  ThemeColor.swift
//  EZMacker
//
//  Created by 박유경 on 5/6/24.
//

import SwiftUI

enum ThemeColorType {
    case darkBlue
    case darkBrown
    case lightGray
    case lightWhite
    case lightBlue
    case lightBlack
    case lightGreen
    case lightYellow
    case lightRed
    
    var color: Color {
        switch self {
        case .darkBlue: return Color(red: 0/255, green: 102/255, blue: 153/255)
        case .darkBrown: return Color(red: 51/255, green: 0/255, blue: 0/255)
        case .lightGray: return Color(red: 227/255, green: 225/255, blue: 225/255)
        case .lightWhite: return Color(red: 232/255, green: 232/255, blue: 232/255)
        case .lightBlue: return Color(red: 51/255, green: 176/255, blue: 200/255)
        case .lightBlack: return Color(red: 10/255, green: 10/255, blue: 10/255)
        case .lightGreen: return Color(red: 100/255, green: 200/255, blue: 100/255)
        case .lightYellow: return Color(red: 220/255, green: 220/255, blue: 10/255)
        case .lightRed: return Color(red: 204/255, green: 0/255, blue: 51/255)
        }
    }
}
