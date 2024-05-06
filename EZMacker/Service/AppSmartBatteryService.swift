//
//  AppSmartBatteryService.swift
//  EZMacker
//
//  Created by 박유경 on 5/5/24.
//

import Foundation
import IOKit.ps
import Combine
protocol AppSmartBatteryRegistryProvidable {
    func getRegistry(forKey key: AppSmartBatteryKeyType) -> AnyPublisher<Any?, Never>
}

struct AppSmartBatteryService: AppSmartBatteryRegistryProvidable {
    let service = IOServiceGetMatchingService(kIOMainPortDefault, IOServiceNameMatching("AppleSmartBattery"))

    func getRegistry(forKey key: AppSmartBatteryKeyType) -> AnyPublisher<Any?, Never> {
        return Future<Any?, Never> { promise in
            guard let result = IORegistryEntryCreateCFProperty(service, key.rawValue as CFString?, nil, 0)?.takeRetainedValue() else {
                Logger.fatalErrorMessage("CFProerty is null")
                return
            }
            promise(.success(result))
        }
        .eraseToAnyPublisher()
    }
}

