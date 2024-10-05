//
//  SmartNotificationAlarmDependency.swift
//  EZMacker
//
//  Created by 박유경 on 9/17/24.
//

import Foundation
import EZMackerServiceLib

struct SmartNotificationAlarmDependency: DependencyRegisterable {
    func register(in container: DependencyContainer) {
        container.register({ context in
            guard let context = context else { fatalError("ModelContext is nil") }
            return AppSettingsManager(context: context) as AppSettingProvidable
        }, forKey: SettingsKey.appSettingsManager.value, lifetime: .transient)
        container.register({ _ in BatterySetting() as BatterySettingConfigurable }, forKey: NotificationAlarmKey.batterySetting.value, lifetime: .transient)
        container.register({ _ in WifiSetting() as WifiSettingConfigurable }, forKey: NotificationAlarmKey.wifiSetting.value, lifetime: .transient)
        container.register({ _ in FileLocatorSetting() as FileLocatorSettingConfigurable }, forKey: NotificationAlarmKey.fileLocatorSetting.value, lifetime: .transient)
    }
}
