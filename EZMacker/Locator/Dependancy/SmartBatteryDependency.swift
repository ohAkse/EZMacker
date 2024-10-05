//
//  SmartBatteryDependency.swift
//  EZMacker
//
//  Created by 박유경 on 9/17/24.
//

import Foundation
import EZMackerServiceLib

protocol DependencyRegisterable {
    func register(in container: DependencyContainer)
}
struct SmartBatteryDependency: DependencyRegisterable {
    func register(in container: DependencyContainer) {
        container.register({ _ in AppSmartBatteryService(serviceKey: IORegServiceKey.batteryService.value) }, forKey: BatteryServiceKey.appSmartBatteryService.value, lifetime: .transient)
    }
}
