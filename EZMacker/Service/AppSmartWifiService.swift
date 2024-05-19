//
//  AppSmartWifiService.swift
//  EZMacker
//
//  Created by 박유경 on 5/19/24.
//

import Foundation
import Combine
protocol AppSmartWifiServiceProvidable {
    func getRegistry(forKey key: AppBCMWLanSkywalkInterfaceType) -> Future<Any?, Never>
}


struct AppSmartWifiService: AppSmartWifiServiceProvidable {

    let service = IOServiceGetMatchingService(kIOMainPortDefault, IOServiceNameMatching("AppleBCMWLANSkywalkInterface"))

    func getRegistry(forKey key: AppBCMWLanSkywalkInterfaceType) -> Future<Any?, Never> {
        return Future<Any?, Never> { promise in
            guard let result = IORegistryEntryCreateCFProperty(service, key.rawValue as CFString?, nil, 0)?.takeRetainedValue() else {
                Logger.fatalErrorMessage("CFProerty is null")
                return
            }
            promise(.success(result))
        }
    }
}
