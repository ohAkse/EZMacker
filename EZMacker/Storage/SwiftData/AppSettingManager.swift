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
            settings.isBatteryWarningMode = value as? Bool ?? false
        case .isBatteryCurrentMessageMode:
            settings.isBatteryCurrentMessageMode = value as? Bool ?? false
        case .batteryPercentage:
            settings.batteryPercentage = value as? String ?? "0"
        case .cpuUsageExitType:
            settings.cpuUsageExitType = value as? String ?? CPUUsageExitType.unused.typeName
        case .bestSSIDShowType:
            settings.ssidShowType = value as? String ?? BestSSIDShowType.alert.typeName
        case .fileLocatorData:
            settings.smartFileLocatorData = value as? Data ?? Data()
        case .isFileChangeAlarmDisabled:
            settings.isFileChangeAlarmDisabled = value as? Bool ?? false
        case .colorSchemeType:
            settings.colorScheme = value as? Int ?? 0
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
            return settings.isBatteryWarningMode as? T
        case .isBatteryCurrentMessageMode:
            return settings.isBatteryCurrentMessageMode as? T
        case .batteryPercentage:
            return settings.batteryPercentage as? T
        case .cpuUsageExitType:
            return settings.cpuUsageExitType as? T
        case .bestSSIDShowType:
            return settings.ssidShowType as? T
        case .fileLocatorData:
            return settings.smartFileLocatorData as? T
        case .isFileChangeAlarmDisabled:
            return settings.isFileChangeAlarmDisabled as? T
        case .colorSchemeType:
            return settings.colorScheme as? T
        }
    }
}
