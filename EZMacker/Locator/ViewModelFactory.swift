//
//  ViewModelFactory.swift
//  EZMacker
//
//  Created by 박유경 on 9/17/24.
//

import Foundation
import EZMackerServiceLib

class ViewModelFactory {
    private let container: DependencyContainer
    
    init(container: DependencyContainer) {
        self.container = container
    }
    
    func createSmartWifiViewModel() -> SmartWifiViewModel<AppSmartWifiService> {
        return SmartWifiViewModel(
            appSmartWifiService: container.resolve(AppSmartWifiService.self, forKey: WifiServiceKey.appSmartWifiService.value),
            systemPreferenceService: container.resolve(SystemPreferenceAccessible.self, forKey: SystemServiceKey.systemPreferenceService.value),
            appCoreWLanWifiService: container.resolve(AppCoreWLANWifiProvidable.self, forKey: WifiServiceKey.appCoreWLanWifiService.value),
            appSettingService: container.resolve(AppSettingProvidable.self, forKey: SettingsKey.appSettingsManager.value),
            appWifiMonitoringService: container.resolve(AppSmartWifiMonitorable.self, forKey: WifiServiceKey.appWifiMonitoringService.value)
        )
    }
    
    func createSmartBatteryViewModel() -> SmartBatteryViewModel<AppSmartBatteryService> {
        return SmartBatteryViewModel(
            appSmartBatteryService: container.resolve(AppSmartBatteryService.self, forKey: BatteryServiceKey.appSmartBatteryService.value),
            appSettingService: container.resolve(AppSettingProvidable.self, forKey: SettingsKey.appSettingsManager.value),
            appProcessService: container.resolve(AppSmartProcessProvidable.self, forKey: ProcessServiceKey.appProcessService.value),
            systemPreferenceService: container.resolve(SystemPreferenceAccessible.self, forKey: SystemServiceKey.systemPreferenceService.value)
        )
    }
    
    func createSmartFileLocatorViewModel() -> SmartFileLocatorViewModel {
        return SmartFileLocatorViewModel(
            appSmartFileService: container.resolve(AppSmartFileProvidable.self, forKey: FileLocatorServiceKey.appSmartFileService.value),
            appSmartFileMonitor: container.resolve(AppSmartFileMonitorable.self, forKey: FileLocatorServiceKey.appFileMonitoringService.value),
            appSmartSettingService: container.resolve(AppSettingProvidable.self, forKey: SettingsKey.appSettingsManager.value)
        )
    }
    
    func createSmartFileSearchViewModel() -> SmartFileSearchViewModel {
        return SmartFileSearchViewModel()
    }
    
    func createSmartNotificationAlarmViewModel() -> SmartNotificationAlarmViewModel {
        return SmartNotificationAlarmViewModel(
            appSettingService: container.resolve(AppSettingProvidable.self, forKey: SettingsKey.appSettingsManager.value),
            appProcessService: container.resolve(AppSmartProcessProvidable.self, forKey: ProcessServiceKey.appProcessService.value),
            batterySetting: container.resolve(BatterySettingConfigurable.self, forKey: NotificationAlarmKey.batterySetting.value),
            wifiSetting: container.resolve(WifiSettingConfigurable.self, forKey: NotificationAlarmKey.wifiSetting.value),
            fileLocatorSetting: container.resolve(FileLocatorSettingConfigurable.self, forKey: NotificationAlarmKey.fileLocatorSetting.value)
        )
    }
    func createSmartImageTunerViewModel() -> SmartImageTunerViewModel {
        return SmartImageTunerViewModel()
    }
}

// MARK: UI용 Preview Factory 주입
extension ViewModelFactory {
    static var preview: ViewModelFactory {
        let container = DependencyContainer.shared
        SmartMockDependency().register(in: container)
        return ViewModelFactory(container: container)
    }
}
