//
//  AppSmartSettingService.swift
//  EZMacker
//
//  Created by 박유경 on 5/26/24.
//

import SwiftUI

protocol AppSmartSettingProvidable {
    func saveConfig<T>(_ key: AppStorageKey, value: T)
    func loadConfig<T>(_ key: AppStorageKey) -> T?
}

struct AppSmartSettingsService: AppSmartSettingProvidable {
    @AppStorage(AppStorageKey.isBatteryWarningMode.name) var isBatteryWarningMode: Bool = AppStorageKey.isBatteryWarningMode.byDefault as? Bool ?? false
    @AppStorage(AppStorageKey.isBattryCurrentMessageMode.name) var isBatteryCurrentMessageMode: Bool = AppStorageKey.isBattryCurrentMessageMode.byDefault as? Bool ?? false
    @AppStorage(AppStorageKey.batteryPercentage.name) var batteryPercentage: String = AppStorageKey.batteryPercentage.byDefault as? String ?? "0"
    @AppStorage(AppStorageKey.appExitMode.name) private var selectedAppExitMode: String = AppStorageKey.appExitMode.byDefault as? String ?? "unused"
    @AppStorage(AppStorageKey.bestSSidShowMode.name) private var selectedBestSSidMode: String = AppStorageKey.bestSSidShowMode.byDefault as? String ?? "alert"
    @AppStorage(AppStorageKey.fileLocatorData.name) private var smartFileLocatorData: Data = AppStorageKey.fileLocatorData.byDefault as? Data ?? Data()
    @AppStorage(AppStorageKey.isFileChangeAlarmDisabled.name) var isFileChangeAlarmDisabled: Bool = AppStorageKey.isFileChangeAlarmDisabled.byDefault as? Bool ?? false
    
    func saveConfig<T>(_ key: AppStorageKey, value: T) {
        switch key {
        case .isBatteryWarningMode, .isBattryCurrentMessageMode, .isFileChangeAlarmDisabled:
            if let boolValue = value as? Bool {
                switch key {
                case .isBatteryWarningMode: isBatteryWarningMode = boolValue
                case .isBattryCurrentMessageMode: isBatteryCurrentMessageMode = boolValue
                case .isFileChangeAlarmDisabled: isFileChangeAlarmDisabled = boolValue
                default:
                    return
                }
            }
        case .batteryPercentage, .appExitMode, .bestSSidShowMode:
            if let stringValue = value as? String {
                switch key {
                case .batteryPercentage: batteryPercentage = stringValue
                case .appExitMode: selectedAppExitMode = stringValue
                case .bestSSidShowMode: selectedBestSSidMode = stringValue
                default:
                    return
                }
            }
        case .fileLocatorData:
            if let dataValue = value as? Data {
                smartFileLocatorData = dataValue
            }
        default:
            return
        }
    }
    
    func loadConfig<T>(_ key: AppStorageKey) -> T? {
        let appStorageKey: [AppStorageKey: Any] = [
            .isBatteryWarningMode: isBatteryWarningMode,
            .isBattryCurrentMessageMode: isBatteryCurrentMessageMode,
            .isFileChangeAlarmDisabled: isFileChangeAlarmDisabled,
            .batteryPercentage: batteryPercentage,
            .appExitMode: selectedAppExitMode,
            .bestSSidShowMode: selectedBestSSidMode,
            .fileLocatorData: smartFileLocatorData
        ]
        return appStorageKey[key] as? T
    }
}
