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
    case isBatteryFullCapacityAlarmeMode
    case batteryPercentage
    case ssidShowType
    case ssidFindTimer
    case cpuUsageExitType
    case fileLocatorData
    case isFileChangeAlarmDisabled
    
    var name: String {
        switch self {
        case .colorSchemeType:
            return "colorSchemeType"
        case .isBatteryChargingErrorMode:
            return "isBatteryWarningMode"
        case .isBatteryFullCapacityAlarmeMode:
            return "isBatteryFullCapacityAlarmeMode"
        case .ssidShowType:
            return "ssidShowType"
        case .ssidFindTimer:
            return "ssidFindTimer"
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
        case .isBatteryFullCapacityAlarmeMode:
            return false
        case .ssidShowType:
            return "alert"
        case .ssidFindTimer:
            return "0"
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
