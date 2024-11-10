//
//  AppSettingManager.swift
//  EZMacker
//
//  Created by 박유경 on 9/14/24.
//

import Foundation
import SwiftData
import EZMackerUtilLib

protocol AppSettingProvidable {
    func saveConfig<T>(_ key: AppStorageKey, value: T)
    func loadConfig<T>(_ key: AppStorageKey) -> T?
}

class AppSettingsManager: AppSettingProvidable {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    private func getOrCreateSettings() -> AppSettings {
        let descriptor = FetchDescriptor<AppSettings>()
        let settings = try? context.fetch(descriptor)
        return settings?.first ?? {
            let newSettings = AppSettings()
            context.insert(newSettings)
            return newSettings
        }()
    }
    
    func saveConfig<T>(_ key: AppStorageKey, value: T) {
        let settings = getOrCreateSettings()
        
        switch key {
        case .isBatteryChargingErrorMode:
            settings.batteryConfiguration.isWarningMode = value as? Bool ?? false
        case .isBatteryCurrentMessageMode:
            settings.batteryConfiguration.isCurrentMessageMode = value as? Bool ?? false
        case .batteryPercentage:
            settings.batteryConfiguration.percentage = value as? String ?? "0"
        case .cpuUsageExitType:
            settings.batteryConfiguration.cpuUsageExitType = value as? String ?? CPUUsageExitType.unused.typeName
        case .bestSSIDShowType:
            settings.wifiConfiguration.ssidShowType = value as? String ?? BestSSIDShowType.alert.typeName
        case .fileLocatorData:
            settings.fileLocatorConfiguration.locatorData = value as? Data ?? Data()
        case .isFileChangeAlarmDisabled:
            settings.fileLocatorConfiguration.isChangeAlarmDisabled = value as? Bool ?? false
        case .colorSchemeType:
            settings.systemPreferenceConfiguration.colorScheme = value as? Int ?? 0
        }
        
        do {
            try context.save()
        } catch {
            Logger.writeLog(.fatal, message: "Failed to save settings: \(error)")
        }
    }
    
    func loadConfig<T>(_ key: AppStorageKey) -> T? {
        let settings = getOrCreateSettings()
        
        switch key {
        case .isBatteryChargingErrorMode:
            return settings.batteryConfiguration.isWarningMode as? T
        case .isBatteryCurrentMessageMode:
            return settings.batteryConfiguration.isCurrentMessageMode as? T
        case .batteryPercentage:
            return settings.batteryConfiguration.percentage as? T
        case .cpuUsageExitType:
            return settings.batteryConfiguration.cpuUsageExitType as? T
        case .bestSSIDShowType:
            return settings.wifiConfiguration.ssidShowType as? T
        case .fileLocatorData:
            return settings.fileLocatorConfiguration.locatorData as? T
        case .isFileChangeAlarmDisabled:
            return settings.fileLocatorConfiguration.isChangeAlarmDisabled as? T
        case .colorSchemeType:
            return settings.systemPreferenceConfiguration.colorScheme as? T
        }
    }
}
