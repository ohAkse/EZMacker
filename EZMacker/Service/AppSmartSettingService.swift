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




class AppSmartSettingsService: AppSmartSettingProvidable {
    @AppStorage(AppStorageKey.isBatteryWarningMode.name) var isBatteryWarningMode: Bool = AppStorageKey.isBatteryWarningMode.byDefault as! Bool
    @AppStorage(AppStorageKey.isBattryCurrentMessageMode.name) var isBatteryCurrentMessageMode: Bool = AppStorageKey.isBattryCurrentMessageMode.byDefault as! Bool
    @AppStorage(AppStorageKey.batteryPercentage.name) var batteryPercentage: String = AppStorageKey.batteryPercentage.byDefault as! String
    @AppStorage(AppStorageKey.appExitMode.name) private var selectedOptionRaw: String = AppStorageKey.appExitMode.byDefault as! String
    
    var selectedOption: BatteryExitOption {
        get {
            BatteryExitOption(rawValue: selectedOptionRaw) ?? .unused
        }
        set {
            selectedOptionRaw = newValue.rawValue
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
                selectedOptionRaw = value
            }
        default:
            break
        }
    }
    
    func loadConfig<T>(_ key: AppStorageKey) -> T? {
        switch key {
        case .isBatteryWarningMode, .isBattryCurrentMessageMode:
            return isBatteryWarningMode as? T
        case .batteryPercentage:
            return batteryPercentage as? T
        case .appExitMode:
            return selectedOptionRaw as? T
        default:
            return nil
        }
    }
}
