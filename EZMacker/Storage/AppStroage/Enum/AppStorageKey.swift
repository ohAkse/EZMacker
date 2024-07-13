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
    case bestSSidShowMode
    case appExitMode
    
    var name: String {
        switch self {
        case .colorSchme:
            return "colorSchme"
        case .isBatteryWarningMode:
            return "isBatteryWarningMode"
        case .isBattryCurrentMessageMode:
            return "isBattryCurrentMessageMode"
        case .bestSSidShowMode:
            return "bestSSidShowMode"
        case .batteryPercentage:
            return "batteryPercentage"
        case .appExitMode:
            return "appExitMode"
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
        case .bestSSidShowMode:
            return "alert"
        case .batteryPercentage:
            return "0"
        case .appExitMode:
            return "unused"
        }
    }
}


