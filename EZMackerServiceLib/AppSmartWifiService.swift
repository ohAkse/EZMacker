//
//  AppSmartWifiService.swift
//  EZMackerServiceLib
//
//  Created by 박유경 on 9/1/24.
//

import Foundation
import Combine
import EZMackerUtilLib

public protocol AppSmartWifiServiceProvidable: AppSmartServiceProvidable {
    typealias WifiKey = AppBCMWLanSkywalkInterfaceType
    func getRegistry(forKey key: WifiKey) -> Future<Any?, Never>
}

public struct AppSmartWifiService: AppSmartWifiServiceProvidable {
    public var serviceKey: String
    private(set) var service: io_object_t
    
    public init(serviceKey: String) {
        self.serviceKey = serviceKey
        self.service = IOServiceGetMatchingService(kIOMainPortDefault, IOServiceNameMatching(serviceKey))
    }
    public func getRegistry(forKey key: WifiKey) -> Future<Any?, Never> {
        return Future<Any?, Never> { promise in
            guard let result = IORegistryEntryCreateCFProperty(service, key.rawValue as CFString?, nil, 0)?.takeRetainedValue() else {
                Logger.fatalErrorMessage("CFProerty is null")
                return
            }
            promise(.success(result))
        }
    }
}
