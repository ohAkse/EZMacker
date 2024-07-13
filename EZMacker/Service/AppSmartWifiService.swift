//
//  AppSmartWifiService.swift
//  EZMacker
//
//  Created by 박유경 on 5/19/24.
//

import Foundation
import Combine

protocol AppSmartWifiServiceProvidable: AppSmartServiceProvidable {
    typealias wifiKey = AppBCMWLanSkywalkInterfaceType
    func getRegistry(forKey key: wifiKey) -> Future<Any?, Never>
}


struct AppSmartWifiService: AppSmartWifiServiceProvidable {
    var serviceKey: String
    var service: io_object_t
    init(serviceKey: String) {
        self.serviceKey = serviceKey
        self.service = IOServiceGetMatchingService(kIOMainPortDefault, IOServiceNameMatching(serviceKey))
    }
    func getRegistry(forKey key: wifiKey) -> Future<Any?, Never> {
        return Future<Any?, Never> { promise in
            guard let result = IORegistryEntryCreateCFProperty(service, key.rawValue as CFString?, nil, 0)?.takeRetainedValue() else {
                Logger.fatalErrorMessage("CFProerty is null")
                return
            }
            promise(.success(result))
        }
    }
}
