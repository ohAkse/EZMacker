//
//  AppSmartBatteryPowerSourceType.swift
//  EZMackerServiceLib
//
//  Created by 박유경 on 9/1/24.
//

import IOKit.ps

public enum AppSmartBatteryPowerSourceType: String {
    case remainingTime
    case chargingTime
    case batteryHealth

    public var ioRegistryKey: String {
        switch self {
        case .remainingTime:
            return kIOPSTimeToEmptyKey as String
        case .chargingTime:
            return kIOPSTimeToFullChargeKey as String
        case .batteryHealth:
            return kIOPSBatteryHealthKey as String
        }
    }
}
