//
//  AppStorageKey.swift
//  EZMacker
//
//  Created by 박유경 on 9/14/24.
//

import Foundation

enum AppStorageKey: String, Hashable {
    case colorSchemeType
    case isBatteryChargingErrorMode
    case isBatteryCurrentMessageMode
    case batteryPercentage
    case bestSSIDShowType
    case cpuUsageExitType
    case fileLocatorData
    case isFileChangeAlarmDisabled
    
    var name: String {
        switch self {
        case .colorSchemeType:
            return "colorSchemeType"
        case .isBatteryChargingErrorMode:
            return "isBatteryWarningMode"
        case .isBatteryCurrentMessageMode:
            return "isBattryCurrentMessageMode"
        case .bestSSIDShowType:
            return "bestSSIDShowType"
        case .batteryPercentage:
            return "batteryPercentage"
        case .cpuUsageExitType:
            return "cpuUsageExitType"
        case .fileLocatorData:
            return "fileLocatorData"
        case .isFileChangeAlarmDisabled:
            return "isFileChangeAlarmDisabled"
        }
    }
    
    var byDefault: Any {
        switch self {
        case .colorSchemeType:
            return "Light"
        case .isBatteryChargingErrorMode:
            return false
        case .isBatteryCurrentMessageMode:
            return false
        case .bestSSIDShowType:
            return "alert"
        case .batteryPercentage:
            return "0"
        case .cpuUsageExitType:
            return "unused"
        case .fileLocatorData:
            return Data()
        case .isFileChangeAlarmDisabled:
            return false
            
        }
    }
}
