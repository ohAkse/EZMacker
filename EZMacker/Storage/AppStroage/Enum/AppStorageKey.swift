//
//  AppStorageKey.swift
//  EZMacker
//
//  Created by 박유경 on 5/6/24.
//

import Foundation
//savedSmartFileLocatorData
enum AppStorageKey: String, Hashable {
    case colorSchme
    case isBatteryWarningMode
    case isBattryCurrentMessageMode
    case batteryPercentage
    case bestSSidShowMode
    case appExitMode
    case fileLocatorData
    case isFileChangeAlarmDisabled
    
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
        case .fileLocatorData:
            return "fileLocatorData"
        case .isFileChangeAlarmDisabled:
            return "isFileChangeAlarmDisabled"
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
        case .fileLocatorData:
            return Data()
        case .isFileChangeAlarmDisabled:
            return false
            
        }
    }
}


