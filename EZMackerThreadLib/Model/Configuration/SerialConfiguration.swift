//
//  SerialConfiguration.swift
//  EZMackerThreadLib
//
//  Created by 박유경 on 9/15/24.
//

import Foundation

public struct FileMonitoringQueueConfiguration: SerialQueueConfigurable {
    public init() {}
    public var label: String {
        return "[Serial]fileMonitoringQueue"
    }
    public var attributes: DispatchQueue.Attributes {
        return []
    }
    public var signpostName: StaticString {
        return "FileMonitoringQueue"
    }
}

public struct WifiMonitoringQueueConfiguration: SerialQueueConfigurable {
    public init() {}
    public var label: String {
        return "[Serial]wifiMonitoring"
    }
    public var attributes: DispatchQueue.Attributes {
        return []
    }
    public var signpostName: StaticString {
        return "WifiMonitoringQueue"
    }
}

public struct CpuMonitoringQueueConfiguration: SerialQueueConfigurable {
    public init() {}
    public var label: String {
        return "[Serial]cpuMonitoring"
    }
    public var attributes: DispatchQueue.Attributes {
        return []
    }
    public var signpostName: StaticString {
        return "CpuMonitoringQueue"
    }
}
