//
//  ColorSchemeMode.swift
//  EZMacker
//
//  Created by 박유경 on 5/6/24.
//

import Foundation

enum ColorSchemeModeType {
    case Light, Dark
    
    var title: String {
        switch self {
        case .Light:
            return "Light"
        case .Dark:
            return "Dark"
            
        }
    }
    var tag: Int {
        switch self {
        case .Light:
            return 0
        case .Dark:
            return 1
        }
    }
}
