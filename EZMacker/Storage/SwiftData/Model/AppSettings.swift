//
//  AppSettings.swift
//  EZMacker
//
//  Created by 박유경 on 9/14/24.
//

import Foundation
import SwiftData

@Model
class AppSettings {
    var batteryConfiguration: BatteryConfiguration
    var wifiConfiguration: WifiConfiguration
    var fileLocatorConfiguration: FileLocatorConfiguration
    var systemPreferenceConfiguration: SystemPreferenceConfiguration
    
    init(
        batteryConfiguration: BatteryConfiguration = BatteryConfiguration(),
        wifiConfiguration: WifiConfiguration = WifiConfiguration(),
        fileLocatorConfiguration: FileLocatorConfiguration = FileLocatorConfiguration(),
        systemPreferenceConfiguration: SystemPreferenceConfiguration = SystemPreferenceConfiguration()
    ) {
        self.batteryConfiguration = batteryConfiguration
        self.wifiConfiguration = wifiConfiguration
        self.fileLocatorConfiguration = fileLocatorConfiguration
        self.systemPreferenceConfiguration = systemPreferenceConfiguration
    }
}

struct BatteryConfiguration: Codable {
    var isWarningMode: Bool
    var isCurrentMessageMode: Bool
    var percentage: String
    var cpuUsageExitType: String
    
    init(
        isWarningMode: Bool = false,
        isCurrentMessageMode: Bool = false,
        percentage: String = "0",
        cpuUsageExitType: String = CPUUsageExitType.unused.typeName
    ) {
        self.isWarningMode = isWarningMode
        self.isCurrentMessageMode = isCurrentMessageMode
        self.percentage = percentage
        self.cpuUsageExitType = cpuUsageExitType
    }
}

struct WifiConfiguration: Codable {
    var ssidShowType: String
    
    init(ssidShowType: String = BestSSIDShowType.alert.typeName) {
        self.ssidShowType = ssidShowType
    }
}

struct FileLocatorConfiguration: Codable {
    var locatorData: Data
    var isChangeAlarmDisabled: Bool
    
    init(locatorData: Data = Data(), isChangeAlarmDisabled: Bool = false) {
        self.locatorData = locatorData
        self.isChangeAlarmDisabled = isChangeAlarmDisabled
    }
}

struct SystemPreferenceConfiguration: Codable {
    var colorScheme: Int
    
    init(colorScheme: Int = 0) {
        self.colorScheme = colorScheme
    }
}
