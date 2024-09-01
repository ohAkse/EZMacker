//
//  AppSmartBatteryService.swift
//  EZMacker
//
//  Created by 박유경 on 5/5/24.
//

import Foundation
import IOKit.ps
import Combine
import EZMackerUtilLib

protocol AppSmartBatteryRegistryProvidable: AppSmartServiceProvidable {
    typealias BatteryKey = AppSmartBatteryKeyType
    func getRegistry(forKey key: BatteryKey) -> Future<Any?, Never>
    func getPowerSourceValue<T>(for key: AppSmartBatteryPowerSourceType, defaultValue: T) -> Future<T, Never>
}

struct AppSmartBatteryService: AppSmartBatteryRegistryProvidable {
    private (set) var serviceKey: String
    private (set) var service: io_object_t
    init(serviceKey: String) {
        self.serviceKey = serviceKey
        self.service = IOServiceGetMatchingService(kIOMainPortDefault, IOServiceNameMatching(serviceKey))
    }

    func getRegistry(forKey key: BatteryKey) -> Future<Any?, Never> {
        return Future<Any?, Never> { promise in
            guard let result = IORegistryEntryCreateCFProperty(service, key.rawValue as CFString?, nil, 0)?.takeRetainedValue() else {
                Logger.fatalErrorMessage("CFProerty is null")
                return
            }
            promise(.success(result))
        }
    }
    func getPowerSourceValue<T>(for key: AppSmartBatteryPowerSourceType, defaultValue: T) -> Future<T, Never> {
        return Future<T, Never> { promise in
            let psInfo = IOPSCopyPowerSourcesInfo().takeRetainedValue()
            let psList = IOPSCopyPowerSourcesList(psInfo).takeRetainedValue() as [CFTypeRef]
            
            var powerSouceInfo: T = defaultValue
            
            for ps in psList {
                if let psDesc = IOPSGetPowerSourceDescription(psInfo, ps).takeUnretainedValue() as? [String: Any],
                   let timeValue = psDesc[key.ioRegistryKey] as? T {
                    powerSouceInfo = timeValue
                    promise(.success(powerSouceInfo))
                    return
                }
            }
            promise(.success(powerSouceInfo))
        }
    }
}
