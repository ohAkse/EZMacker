//
//  AppSmartBatteryService.swift
//  EZMackerServiceLib
//
//  Created by 박유경 on 9/1/24.
//

import IOKit.ps
import Combine
import EZMackerUtilLib

public protocol AppSmartBatteryRegistryProvidable: AppSmartServiceProvidable {
    typealias BatteryKey = AppSmartBatteryKeyType
    func getRegistry(forKey key: BatteryKey) -> Future<Any?, Never>
    func getPowerSourceValue<T>(for key: AppSmartBatteryPowerSourceType, defaultValue: T) -> Future<T, Never>
}

public struct AppSmartBatteryService: AppSmartBatteryRegistryProvidable {
    public var serviceKey: String
    private(set) var service: io_object_t
    public init(serviceKey: String) {
        self.serviceKey = serviceKey
        self.service = IOServiceGetMatchingService(kIOMainPortDefault, IOServiceNameMatching(serviceKey))
    }

    public func getRegistry(forKey key: BatteryKey) -> Future<Any?, Never> {
        return Future<Any?, Never> { promise in
            guard let result = IORegistryEntryCreateCFProperty(service, key.rawValue as CFString?, nil, 0)?.takeRetainedValue() else {
                Logger.fatalErrorMessage("CFProerty is null")
                return
            }
            promise(.success(result))
        }
    }
    public func getPowerSourceValue<T>(for key: AppSmartBatteryPowerSourceType, defaultValue: T) -> Future<T, Never> {
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
