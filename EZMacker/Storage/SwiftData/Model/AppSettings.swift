//
//  AppSettings.swift
//  EZMacker
//
//  Created by 박유경 on 9/14/24.
//

import Foundation
import SwiftData

// TODO: 모델링화하기
@Model
class AppSettings {
    var isBatteryWarningMode: Bool
    var isBatteryCurrentMessageMode: Bool
    var batteryPercentage: String
    var cpuUsageExitType: String
    // BatterySetting
    var ssidShowType: String
    // WifiSetting
    var smartFileLocatorData: Data
    var isFileChangeAlarmDisabled: Bool
    // FileLocatorSetting
    var colorScheme: Int
    
    init(
        isBatteryWarningMode: Bool = false,
        isBatteryCurrentMessageMode: Bool = false,
        batteryPercentage: String = "0",
        cpuUsageExitType: String = CPUUsageExitType.unused.typeName,
        ssidShowType: String = BestSSIDShowType.alert.typeName,
        smartFileLocatorData: Data = Data(),
        isFileChangeAlarmDisabled: Bool = false,
        colorScheme: Int = 0
    ) {
        self.isBatteryWarningMode = isBatteryWarningMode
        self.isBatteryCurrentMessageMode = isBatteryCurrentMessageMode
        self.batteryPercentage = batteryPercentage
        self.cpuUsageExitType = cpuUsageExitType
        self.ssidShowType = ssidShowType
        self.smartFileLocatorData = smartFileLocatorData
        self.isFileChangeAlarmDisabled = isFileChangeAlarmDisabled
        self.colorScheme = colorScheme
    }
}
