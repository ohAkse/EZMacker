//
//  DispatchQueueConfiguration.swift
//  EZMackerThreadLib
//
//  Created by 박유경 on 9/14/24.
//

import Foundation

public enum DispatchQueueConfiguration {
    case wifiScan
    case commandRun
    case fileMonitoring
    case wifiMonitoring
    case cpuMonitoring

    var label: String {
        switch self {
        case .wifiScan:
            return "ezMacker.wifiScan"
        case .commandRun:
            return "ezMacker.commandRun"
        case .fileMonitoring:
            return "ezMacker.fileMonitoringQueue"
        case .wifiMonitoring:
            return "ezMacker.wifiMonitoring"
        case .cpuMonitoring:
            return "ezMacker.wifiMonitoring"
        }
    }
    
    var attributes: DispatchQueue.Attributes {
        switch self {
        case .wifiScan, .commandRun:
            return .concurrent
        case .fileMonitoring, .wifiMonitoring, .cpuMonitoring:
            return []
        }
    }
}
