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
        container.register({ _ in AppSmartWifiService(serviceKey: IORegServiceKey.wifiService.value) }, forKey: WifiServiceKey.appSmartWifiService.value, lifetime: .transient)
        container.register({ _ in
            AppCoreWLanWifiService(
                wifiClient: CWWiFiClient.shared(),
                wifyKeyChainService: AppWifiKeyChainService(),
                autoConnectionService: AppSmartAutoconnectWifiService()
            ) as AppCoreWLANWifiProvidable
        }, forKey: WifiServiceKey.appCoreWLanWifiService.value, lifetime: .transient)
        container.register({ _ in AppSmartWifiMonitoringService(wifiClient: CWWiFiClient()) as AppSmartWifiMonitorable }, forKey: WifiServiceKey.appWifiMonitoringService.value, lifetime: .transient)
    }
}
