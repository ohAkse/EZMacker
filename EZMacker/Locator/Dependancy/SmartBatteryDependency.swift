//
//  SmartBatteryDependency.swift
//  EZMacker
//
//  Created by 박유경 on 9/17/24.
//

import Foundation
import EZMackerServiceLib

struct SmartBatteryDependency: DependencyRegisterable {
    func register(in container: DependencyContainer) {
        container.register({ _ in AppSmartBatteryService(serviceKey: IORegServiceKey.batteryService.value) }, forKey: BatteryServiceKey.appSmartBatteryService.value)
        container.register({ context in
            guard let context = context else { fatalError("ModelContext is nil") }
            return AppSettingsManager(context: context) as AppSettingProvidable
        }, forKey: SettingsKey.appSettingsManager.value)
        container.register({ _ in AppSmartProcessService() as AppSmartProcessProvidable }, forKey: ProcessServiceKey.appProcessService.value)
        container.register({ _ in SystemPreferenceService() as SystemPreferenceAccessible }, forKey: SystemServiceKey.systemPreferenceService.value)
    }
}
