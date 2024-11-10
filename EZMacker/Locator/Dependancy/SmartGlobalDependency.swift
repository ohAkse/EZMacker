//
//  SmartGlobalDependency.swift
//  EZMacker
//
//  Created by 박유경 on 9/17/24.
//

import Foundation
import EZMackerServiceLib
import EZMackerUtilLib

struct SmartGlobalDependency: DependencyRegisterable {
    func register(in container: DependencyContainer) {
        container.register({ context in
            guard let context = context else { fatalError("ModelContext is nil") }
            return AppSettingsManager(context: context) as AppSettingProvidable
        }, forKey: SettingsKey.appSettingsManager.value, lifetime: .singleton)
        container.register({ _ in SystemPreferenceService() as SystemPreferenceAccessible }, forKey: SystemServiceKey.systemPreferenceService.value, lifetime: .singleton)
        container.register({ _ in AppSmartProcessService() as AppSmartProcessProvidable }, forKey: ProcessServiceKey.appProcessService.value, lifetime: .singleton)
    }
}
