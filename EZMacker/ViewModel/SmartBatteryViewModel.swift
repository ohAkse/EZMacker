//
//  SmartBatteryViewModel.swift
//  EZMacker
//
//  Created by 박유경 on 5/5/24.
//

import Foundation

class SmartBatteryViewModel: ObservableObject {
    private let appSmartBatterySerivce: AppSmartBatteryRegistryProvidable
    
    init(appSmartBatteryService: AppSmartBatteryService) {
        self.appSmartBatterySerivce = appSmartBatteryService
        let _ = appSmartBatterySerivce.getRegistry(forKey: .AbsoluteCapacity)
    }
}
