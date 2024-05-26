//
//  AppStorageKey.swift
//  EZMacker
//
//  Created by 박유경 on 5/6/24.
//

import Foundation

enum AppStorageKey: String, Hashable {
    case colorSchme
    case isBatteryWarningMode
    case isBattryCurrentMessageMode
    case batteryPercentage
    case appExitMode
    
    var name: String {
        switch self {
        case .colorSchme:
            return "colorSchme"
        case .isBatteryWarningMode:
            return "isBatteryWarningMode"
        case .isBattryCurrentMessageMode:
            return "isBattryCurrentMessageMode"
        case .batteryPercentage:
            return "batteryPercentage"
        case .appExitMode:
            return "selectedOption"
        }
    }
    
    var byDefault: Any {
        switch self {
        case .colorSchme:
            return "Light"
        case .isBatteryWarningMode:
            return false
        case .isBattryCurrentMessageMode:
            return false
        case .batteryPercentage:
            return "0"
        case .appExitMode:
            return "unused"
        }
    }
}


