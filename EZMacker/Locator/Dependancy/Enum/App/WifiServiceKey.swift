//
//  WifiServiceKey.swift
//  EZMacker
//
//  Created by 박유경 on 9/17/24.
//

enum WifiServiceKey: String {
    case appSmartWifiService
    case appCoreWLanWifiService
    case appWifiMonitoringService

    var value: String { self.rawValue }
}
