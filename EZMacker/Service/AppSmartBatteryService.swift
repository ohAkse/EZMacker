//
//  AppSmartBatteryService.swift
//  EZMacker
//
//  Created by 박유경 on 5/5/24.
//

import Foundation
protocol AppSmartBatteryRegistryProvidable {
    func getRegistry(forKey key:AppSmartBatteryKeyType) ->Any?
    
}

struct AppSmartBatteryService: AppSmartBatteryRegistryProvidable {
    func getRegistry(forKey key: AppSmartBatteryKeyType) -> Any? {
        print("AppSmartBatteryService getRegistry called")
        return nil
    }
}
