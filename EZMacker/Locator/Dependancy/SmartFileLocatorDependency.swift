//
//  SmartFileLocatorDependency.swift
//  EZMacker
//
//  Created by 박유경 on 9/17/24.
//

import Foundation
import EZMackerServiceLib

struct SmartFileLocatorDependency: DependencyRegisterable {
    func register(in container: DependencyContainer) {
        container.register({ _ in AppSmartFileService() as AppSmartFileProvidable }, forKey: FileLocatorServiceKey.appSmartFileService.rawValue, lifetime: .transient)
        container.register({ _ in AppSmartFileMonitoringService() as AppSmartFileMonitorable }, forKey: FileLocatorServiceKey.appFileMonitoringService.value, lifetime: .transient)
    }
}
