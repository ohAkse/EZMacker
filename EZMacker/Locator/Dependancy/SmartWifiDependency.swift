//
//  SmartWifiDependency.swift
//  EZMacker
//
//  Created by 박유경 on 9/17/24.
//

import Foundation
import EZMackerServiceLib
import CoreWLAN

struct SmartWifiDependency: DependencyRegisterable {
    func register(in container: DependencyContainer) {
        container.register({ _ in AppSmartWifiService(serviceKey: IORegServiceKey.wifiService.value) }, forKey: WifiServiceKey.appSmartWifiService.value)
        container.register({ _ in SystemPreferenceService() as SystemPreferenceAccessible }, forKey: SystemServiceKey.systemPreferenceService.value)
        container.register({ _ in
            AppCoreWLanWifiService(
                wifiClient: CWWiFiClient.shared(),
                wifyKeyChainService: AppWifiKeyChainService(),
                autoConnectionService: AppSmartAutoconnectWifiService()
            ) as AppCoreWLANWifiProvidable
        }, forKey: WifiServiceKey.appCoreWLanWifiService.value)
        container.register({ context in
            guard let context = context else { fatalError("ModelContext is nil") }
            return AppSettingsManager(context: context) as AppSettingProvidable
        }, forKey: SettingsKey.appSettingsManager.value)
        container.register({ _ in AppSmartWifiMonitoringService(wifiClient: CWWiFiClient()) as AppSmartWifiMonitorable }, forKey: WifiServiceKey.appWifiMonitoringService.value)
    }
}
