//
//  ToolbarKey.swift
//  EZMacker
//
//  Created by 박유경 on 5/6/24.
//

import Foundation
enum ToolbarKeyType: String {
    case MainToolbar
    case ColorSchemeButton
    case ColorSchemePicker
    var name:String {
        switch self{
        case .MainToolbar:
            return "MainToolbar"
        case .ColorSchemeButton:
            return "ColorSchemeButton"
        case .ColorSchemePicker:
            return "ColorSchemePicker"
        }
    }
}

enum ToolbarImage {
    case colorSchemeButton
    
    var systemName: String {
        switch self {
        case .colorSchemeButton:
            return "circle.righthalf.filled"
        }
    }
}
