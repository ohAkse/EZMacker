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
        case .isBatteryFullCapacityAlarmeMode:
            settings.batteryConfiguration.isCurrentMessageMode = value as? Bool ?? false
        case .batteryPercentage:
            settings.batteryConfiguration.percentage = value as? String ?? "0"
        case .cpuUsageExitType:
            settings.batteryConfiguration.cpuUsageExitType = value as? String ?? CPUUsageExitType.unused.typeName
        case .ssidShowType:
            settings.wifiConfiguration.ssidShowType = value as? String ?? SSIDShowType.alert.typeName
        case .ssidFindTimer:
            settings.wifiConfiguration.ssidFindTimer = value as? String ?? "0"
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
            context.rollback()
            Logger.writeLog(.fatal, message: "Failed to save settings: \(error)")
        }
    }
    
    func loadConfig<T>(_ key: AppStorageKey) -> T? {
        let settings = getOrCreateSettings()
        
        // 타입에 따른 적절한 기본값 처리
        switch key {
        case .isBatteryChargingErrorMode:
            if T.self == Bool.self {
                return settings.batteryConfiguration.isWarningMode as? T
            }
        case .isBatteryFullCapacityAlarmeMode:
            if T.self == Bool.self {
                return settings.batteryConfiguration.isCurrentMessageMode as? T
            }
        case .batteryPercentage:
            if T.self == String.self {
                return settings.batteryConfiguration.percentage as? T
            }
        case .cpuUsageExitType:
            if T.self == String.self {
                return settings.batteryConfiguration.cpuUsageExitType as? T
            }
        case .ssidShowType:
            if T.self == String.self {
                return settings.wifiConfiguration.ssidShowType as? T
            }
        case .ssidFindTimer:
            if T.self == String.self {
                return settings.wifiConfiguration.ssidFindTimer as? T
            }
        case .fileLocatorData:
            if T.self == Data.self {
                return settings.fileLocatorConfiguration.locatorData as? T
            }
        case .isFileChangeAlarmDisabled:
            if T.self == Bool.self {
                return settings.fileLocatorConfiguration.isChangeAlarmDisabled as? T
            }
        case .colorSchemeType:
            if T.self == Int.self {
                return settings.systemPreferenceConfiguration.colorScheme as? T
            }
        }
        return nil
    }
}
