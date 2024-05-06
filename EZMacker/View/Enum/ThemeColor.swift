//
//  ThemeColor.swift
//  EZMacker
//
//  Created by 박유경 on 5/6/24.
//

import SwiftUI

enum ThemeColor {
    case darkBlue
    case darkWhite
    case lightGray
    case lightWhite
    case lightBlue
    case lightBlack
    case lightGreen
    
    var color: Color {
        switch self {
        case .darkBlue: return Color(red: 54/255, green: 76/255, blue: 110/255)
        case .darkWhite: return Color(red: 131/255, green: 158/255, blue: 183/255)
        case .lightGray: return Color(red: 227/255, green: 225/255, blue: 225/255)
        case .lightWhite: return Color(red: 232/255, green: 232/255, blue: 232/255)
        case .lightBlue: return Color(red: 154/255, green: 176/255, blue: 200/255)
        case .lightBlack: return Color(red: 10/255, green: 10/255, blue: 10/255)
        case .lightGreen: return Color(red: 100/255, green: 255/255, blue: 100/255)
        }
    }
}
