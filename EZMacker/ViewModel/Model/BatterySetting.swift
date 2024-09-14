//
//  BatterySetting.swift
//  EZMacker
//
//  Created by 박유경 on 8/17/24.
//

protocol BatterySettingConfigurable {
    var isBatteryWarningMode: Bool { get set }
    var isBatteryCurrentMessageMode: Bool { get set }
    var batteryPercentage: String { get set }
    var cpuUsageExitType: CPUUsageExitType { get set }
}

struct BatterySetting: BatterySettingConfigurable {
    var isBatteryWarningMode: Bool = false
    var isBatteryCurrentMessageMode: Bool = false
    var batteryPercentage: String = ""
    var cpuUsageExitType: CPUUsageExitType = .unused
}
