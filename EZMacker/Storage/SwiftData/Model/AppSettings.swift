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
    var isBatteryWarningMode: Bool
    var isBatteryCurrentMessageMode: Bool
    var batteryPercentage: String
    var cpuUsageExitType: String // 배터리 관련 설정
    var ssidShowType: String // 와이파이 관련 설정
    var smartFileLocatorData: Data // 파일 로케이터 데이터
    var isFileChangeAlarmDisabled: Bool // 알람
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
