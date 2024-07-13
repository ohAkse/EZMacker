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
//TODO: 이 서비스는 앱에 관한 설정값들을 Save/Load하는부분으로써 밑에 키값(Wifi,FileLocator)저장값들은 따로 구분시킬것
struct AppSmartSettingsService: AppSmartSettingProvidable {
    @AppStorage(AppStorageKey.isBatteryWarningMode.name) var isBatteryWarningMode: Bool = AppStorageKey.isBatteryWarningMode.byDefault as! Bool
    @AppStorage(AppStorageKey.isBattryCurrentMessageMode.name) var isBatteryCurrentMessageMode: Bool = AppStorageKey.isBattryCurrentMessageMode.byDefault as! Bool
    @AppStorage(AppStorageKey.batteryPercentage.name) var batteryPercentage: String = AppStorageKey.batteryPercentage.byDefault as! String
    @AppStorage(AppStorageKey.appExitMode.name) private var selectedAppExitMode: String = AppStorageKey.appExitMode.byDefault as! String
    //나중에 처리할것
    @AppStorage(AppStorageKey.bestSSidShowMode.name) private var selectedBestSSidMode: String = AppStorageKey.bestSSidShowMode.byDefault as! String
    @AppStorage(AppStorageKey.fileLocatorData.name) private var smartFileLocatorData: Data = AppStorageKey.fileLocatorData.byDefault as! Data
    
    
    var selectedOption: AppUsageExitOption {
        get {
            AppUsageExitOption(rawValue: selectedAppExitMode) ?? .unused
        }
        set {
            selectedAppExitMode = newValue.rawValue
        }
    }
    
    func saveConfig<T>(_ key: AppStorageKey, value: T) {
        switch key {
        case .isBatteryWarningMode:
            if let value = value as? Bool {
                isBatteryWarningMode = value
            }
        case .isBattryCurrentMessageMode:
            if let value = value as? Bool {
                isBatteryCurrentMessageMode = value
            }
        case .batteryPercentage:
            if let value = value as? String {
                batteryPercentage = value
            }
        case .appExitMode:
            if let value = value as? String {
                selectedAppExitMode = value
            }
        case .bestSSidShowMode:
            if let value = value as? String {
                selectedBestSSidMode = value
            }
        case .fileLocatorData:
            if let value = value as? Data {
                smartFileLocatorData = value
            }
        default:
            break
        }
    }
    
    func loadConfig<T>(_ key: AppStorageKey) -> T? {
        switch key {
        case .isBattryCurrentMessageMode:
            return isBatteryCurrentMessageMode as? T
        case .isBatteryWarningMode:
            return isBatteryWarningMode as? T
        case .batteryPercentage:
            return batteryPercentage as? T
        case .appExitMode:
            return selectedAppExitMode as? T
        case .bestSSidShowMode:
            return selectedBestSSidMode as? T
        case .fileLocatorData:
              return smartFileLocatorData as? T
        default:
            return nil
        }
    }
}
