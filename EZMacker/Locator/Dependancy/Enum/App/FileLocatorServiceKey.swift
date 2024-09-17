//
//  FileLocatorServiceKey.swift
//  EZMacker
//
//  Created by 박유경 on 9/17/24.
//

enum FileLocatorServiceKey: String {
    case appSmartFileService
    case appFileMonitoringService

    var value: String { self.rawValue }
}
