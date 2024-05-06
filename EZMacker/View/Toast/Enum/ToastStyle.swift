//
//  ToastStyle.swift
//  EZMacker
//
//  Created by 박유경 on 5/6/24.
//

import SwiftUI

enum ToastStyle {
    case error
    case warning
    case success
    case info
    
    var themeColor: Color {
        switch self {
        case .error: return ThemeColor.lightRed.color
        case .warning: return ThemeColor.lightYellow.color
        case .info: return ThemeColor.lightGreen.color
        case .success: return ThemeColor.lightBlue.color
        }
    }
    
    var iconFileName: String {
        switch self {
        case .info: return "info.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
        }
    }
}
