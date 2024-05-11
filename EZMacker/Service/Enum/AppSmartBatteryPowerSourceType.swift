//
//  AppSmartBatteryPowerSourceType.swift
//  EZMacker
//
//  Created by 박유경 on 5/10/24.
//

import Foundation
enum AppSmartBatteryPowerSourceType: String {
    case remainingTime
    case chargingTime
    case batteryHealth

    var ioRegistryKey: String {
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
